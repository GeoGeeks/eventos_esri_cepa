import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'accion_notificacion.dart';
import 'notificaciones_repository.dart';

/// Handler de mensajes recibidos con la app en segundo plano/terminada.
///
/// TIENE que ser una función de nivel superior (no un método de instancia) -
/// requisito de `FirebaseMessaging.onBackgroundMessage`, que la registra
/// como entry-point de un isolate separado que el sistema operativo crea
/// para procesar el push sin traer toda la UI a memoria. No hace falta
/// `Firebase.initializeApp()` aquí: el plugin ya garantiza tener Firebase
/// inicializado en ese isolate antes de invocar esto.
///
/// Cuerpo vacío a propósito por ahora: Android/iOS ya muestran la
/// notificación del sistema solos en este caso (a diferencia de foreground,
/// ver `PushNotificacionesService._mostrarNotificacionLocal`) con solo tener
/// el `notification` block del payload - este handler es el lugar para,
/// más adelante, sincronizar datos en background antes de que el usuario
/// abra la app (ej. refrescar `EventosStore`), no para mostrar nada.
@pragma('vm:entry-point')
Future<void> manejarMensajeEnSegundoPlano(RemoteMessage mensaje) async {}

/// Integración Dart de FCM: permiso, device token, y los tres estados de
/// llegada de un push (foreground/background/terminada - ver
/// `configurarListeners`). La configuración nativa (SDKs, `google-services.json`/
/// `GoogleService-Info.plist`, entitlements) ya está lista por separado, ver
/// `CLAUDE.md`.
///
/// Al tocar una notificación (la del sistema o la que se pinta con la app
/// abierta) la marca como leída y, SOLO si la campaña trae contenido
/// vinculado ([AccionNotificacion]), lo abre con [alAbrirContenido]. Sin
/// contenido vinculado la app abre donde le toque, como siempre.
class PushNotificacionesService {
  /// Quién abre el contenido vinculado - lo conecta `_Arranque` (main.dart)
  /// con el navegador raíz; este servicio no conoce pantallas.
  static Future<void> Function(AccionNotificacion accion)? alAbrirContenido;

  PushNotificacionesService({
    NotificacionesRepository? repository,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? notificacionesLocales,
  }) : _repository = repository ?? NotificacionesRepository(),
       _messaging = messaging ?? FirebaseMessaging.instance,
       _notificacionesLocales =
           notificacionesLocales ?? FlutterLocalNotificationsPlugin();

  final NotificacionesRepository _repository;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _notificacionesLocales;

  static const _canalId = 'push_general';
  static const _canalNombre = 'Notificaciones';
  static const _canalDescripcion =
      'Avisos de eventos, agenda y novedades de Esri Colombia.';

  bool _notificacionesLocalesListas = false;

  /// Pide permiso al usuario, obtiene el device token actual y lo registra
  /// contra el backend (`POST /notificaciones/device-token`) - se llama una
  /// vez por sesión iniciada (ver `Menu.initState`), nunca desde `main()`
  /// porque ahí todavía no hay un asistente autenticado a quien asociar el
  /// token. Deja además un listener de `onTokenRefresh` para que un token
  /// rotado por el sistema operativo se vuelva a registrar solo.
  ///
  /// Si el usuario niega el permiso, no falla - solo no habrá push para
  /// este dispositivo hasta que lo habilite manualmente desde los ajustes
  /// del sistema (no hay, todavía, una pantalla propia que se lo pida de
  /// nuevo).
  Future<void> registrarParaSesionActual() async {
    final permiso = await _messaging.requestPermission();
    if (permiso.authorizationStatus == AuthorizationStatus.denied) return;

    await _inicializarNotificacionesLocales();

    final token = await _messaging.getToken();
    if (token != null) await _registrarToken(token);

    _messaging.onTokenRefresh.listen(_registrarToken);
  }

  /// Deja activos los listeners de los tres estados en los que puede llegar
  /// un push - separado de `registrarParaSesionActual` porque debe quedar
  /// escuchando mientras la app esté viva, no solo en el momento puntual del
  /// login (`verificarSesionExistente` puede restaurar sesión sin pasar por
  /// ahí). Seguro de llamar más de una vez si `Menu` se reconstruye -
  /// `FirebaseMessaging` no duplica el listener por handler idéntico, pero
  /// aun así el llamador (ver `Menu.initState`) solo lo hace una vez por
  /// ciclo de vida del widget.
  void configurarListeners() {
    FirebaseMessaging.onMessage.listen(_mostrarNotificacionLocal);
    FirebaseMessaging.onMessageOpenedApp.listen(_alAbrirNotificacion);
    // App abierta desde terminada tocando la notificación - a diferencia de
    // los dos de arriba, este es un Future de una sola vez, no un Stream.
    _messaging.getInitialMessage().then((mensaje) {
      if (mensaje != null) _alAbrirNotificacion(mensaje);
    });
  }

  Future<void> _registrarToken(String token) {
    return _repository.registrarDeviceToken(
      token: token,
      plataforma: Platform.isIOS ? 'IOS' : 'ANDROID',
    );
  }

  Future<void> _alAbrirNotificacion(RemoteMessage mensaje) =>
      _alTocar(mensaje.data);

  /// Marca como leída y abre el contenido vinculado, si lo hay. Que falle
  /// marcarla no impide abrir el contenido.
  Future<void> _alTocar(Map<String, dynamic> data) async {
    final idNotificacion = data['notificacionId'] as String?;
    if (idNotificacion != null) {
      try {
        await _repository.marcarLeido(idNotificacion);
      } catch (_) {}
    }
    final accion = AccionNotificacion.desdeData(data);
    if (accion != null) await alAbrirContenido?.call(accion);
  }

  /// Toque a la notificación pintada a mano con la app abierta: su
  /// `payload` es el `data` del push (ver `_mostrarNotificacionLocal`).
  void _alTocarNotificacionLocal(NotificationResponse respuesta) {
    final payload = respuesta.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final data = jsonDecode(payload);
      if (data is Map<String, dynamic>) _alTocar(data);
    } on FormatException {
      // Payload ajeno: no hay nada que abrir.
    }
  }

  /// Android/iOS solo muestran la notificación del sistema automáticamente
  /// cuando la app está en background/terminada - en foreground, FCM
  /// entrega el mensaje a `onMessage` y **no** la pinta sola, hay que
  /// mostrarla a mano con `flutter_local_notifications` para que el
  /// asistente la vea igual si tiene la app abierta.
  Future<void> _mostrarNotificacionLocal(RemoteMessage mensaje) async {
    final notificacion = mensaje.notification;
    if (notificacion == null) return;

    await _notificacionesLocales.show(
      id: mensaje.hashCode,
      title: notificacion.title,
      body: notificacion.body,
      payload: jsonEncode(mensaje.data),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _canalId,
          _canalNombre,
          channelDescription: _canalDescripcion,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _inicializarNotificacionesLocales() async {
    if (_notificacionesLocalesListas) return;
    _notificacionesLocalesListas = true;

    await _notificacionesLocales.initialize(
      settings: const InitializationSettings(
        // `launcher_icon` es el ícono real de la app (ver
        // `flutter_launcher_icons` en pubspec.yaml) - `ic_launcher` sigue
        // existiendo en los mipmap pero es el placeholder huérfano de
        // Flutter, no el ícono de marca (ver CLAUDE.md, "Superado ...
        // ícono de marca original").
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _alTocarNotificacionLocal,
    );

    await _notificacionesLocales
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _canalId,
            _canalNombre,
            description: _canalDescripcion,
            importance: Importance.high,
          ),
        );
  }
}
