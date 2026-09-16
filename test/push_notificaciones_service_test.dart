import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/notificaciones/data/notificaciones_repository.dart';
import 'package:esri_eventos/features/notificaciones/data/push_notificaciones_service.dart';

class _MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class _MockNotificacionesRepository extends Mock
    implements NotificacionesRepository {}

class _MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

// `NotificationSettings` no tiene factory de conveniencia en el paquete -
// todos sus campos son requeridos (ver
// firebase_messaging_platform_interface). Este helper solo fija el único que
// le importa a `PushNotificacionesService` (`authorizationStatus`).
NotificationSettings _permiso(AuthorizationStatus estado) {
  return NotificationSettings(
    authorizationStatus: estado,
    alert: AppleNotificationSetting.notSupported,
    announcement: AppleNotificationSetting.notSupported,
    badge: AppleNotificationSetting.notSupported,
    carPlay: AppleNotificationSetting.notSupported,
    lockScreen: AppleNotificationSetting.notSupported,
    notificationCenter: AppleNotificationSetting.notSupported,
    showPreviews: AppleShowPreviewSetting.notSupported,
    timeSensitive: AppleNotificationSetting.notSupported,
    criticalAlert: AppleNotificationSetting.notSupported,
    sound: AppleNotificationSetting.notSupported,
    providesAppNotificationSettings: AppleNotificationSetting.notSupported,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const NotificationDetails(iOS: DarwinNotificationDetails()),
    );
    registerFallbackValue(
      const InitializationSettings(iOS: DarwinInitializationSettings()),
    );
  });

  late _MockFirebaseMessaging messaging;
  late _MockNotificacionesRepository repository;
  late _MockFlutterLocalNotificationsPlugin notificacionesLocales;
  late PushNotificacionesService servicio;

  setUp(() {
    messaging = _MockFirebaseMessaging();
    repository = _MockNotificacionesRepository();
    notificacionesLocales = _MockFlutterLocalNotificationsPlugin();
    servicio = PushNotificacionesService(
      messaging: messaging,
      repository: repository,
      notificacionesLocales: notificacionesLocales,
    );

    when(() => messaging.onTokenRefresh).thenAnswer((_) => const Stream.empty());
    when(
      () => notificacionesLocales.initialize(
        settings: any(named: 'settings'),
        onDidReceiveNotificationResponse:
            any(named: 'onDidReceiveNotificationResponse'),
        onDidReceiveBackgroundNotificationResponse:
            any(named: 'onDidReceiveBackgroundNotificationResponse'),
      ),
    ).thenAnswer((_) async => true);
    when(
      () => notificacionesLocales
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>(),
    ).thenReturn(null);
  });

  group('registrarParaSesionActual', () {
    test('permiso denegado: no pide token ni registra nada', () async {
      when(() => messaging.requestPermission())
          .thenAnswer((_) async => _permiso(AuthorizationStatus.denied));

      await servicio.registrarParaSesionActual();

      verifyNever(() => messaging.getToken());
      verifyNever(
        () => repository.registrarDeviceToken(
          token: any(named: 'token'),
          plataforma: any(named: 'plataforma'),
        ),
      );
    });

    test('permiso autorizado y token presente: lo registra en el backend', () async {
      when(() => messaging.requestPermission())
          .thenAnswer((_) async => _permiso(AuthorizationStatus.authorized));
      when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token-1');
      when(
        () => repository.registrarDeviceToken(
          token: any(named: 'token'),
          plataforma: any(named: 'plataforma'),
        ),
      ).thenAnswer((_) async {});

      await servicio.registrarParaSesionActual();

      verify(
        () => repository.registrarDeviceToken(
          token: 'fcm-token-1',
          plataforma: any(named: 'plataforma'),
        ),
      ).called(1);
    });

    test('permiso autorizado pero sin token todavía: no llama al backend', () async {
      when(() => messaging.requestPermission())
          .thenAnswer((_) async => _permiso(AuthorizationStatus.authorized));
      when(() => messaging.getToken()).thenAnswer((_) async => null);

      await servicio.registrarParaSesionActual();

      verifyNever(
        () => repository.registrarDeviceToken(
          token: any(named: 'token'),
          plataforma: any(named: 'plataforma'),
        ),
      );
    });

    test('un token refrescado más tarde también se registra', () async {
      when(() => messaging.requestPermission())
          .thenAnswer((_) async => _permiso(AuthorizationStatus.authorized));
      when(() => messaging.getToken()).thenAnswer((_) async => 'fcm-token-1');
      when(() => messaging.onTokenRefresh)
          .thenAnswer((_) => Stream.value('fcm-token-2'));
      when(
        () => repository.registrarDeviceToken(
          token: any(named: 'token'),
          plataforma: any(named: 'plataforma'),
        ),
      ).thenAnswer((_) async {});

      await servicio.registrarParaSesionActual();
      // El listener de onTokenRefresh corre en una microtask aparte.
      await Future<void>.delayed(Duration.zero);

      verify(
        () => repository.registrarDeviceToken(
          token: 'fcm-token-1',
          plataforma: any(named: 'plataforma'),
        ),
      ).called(1);
      verify(
        () => repository.registrarDeviceToken(
          token: 'fcm-token-2',
          plataforma: any(named: 'plataforma'),
        ),
      ).called(1);
    });
  });
}
