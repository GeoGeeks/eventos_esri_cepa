import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher_platform_interface/link.dart' show LinkDelegate;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:esri_eventos/features/notificaciones/data/notificacion_recibida.dart';
import 'package:esri_eventos/features/notificaciones/data/notificaciones_repository.dart';
import 'package:esri_eventos/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:esri_eventos/features/notifications/presentation/widgets/empty_notifications.dart';
import 'package:esri_eventos/features/notifications/presentation/widgets/notification_item.dart';

import 'fuentes_de_prueba.dart';

NotificacionRecibida _item(
  String id, {
  bool leida = false,
  DateTime? fecha,
  String? accionRuta,
}) {
  return NotificacionRecibida(
    id: id,
    notificacionId: 'campana-$id',
    titulo: 'Actualización del evento',
    cuerpo: 'Se ha modificado la hora de inicio.',
    leida: leida,
    fecha: fecha ?? DateTime.now(),
    accionRuta: accionRuta,
  );
}

/// Reemplaza [UrlLauncherPlatform.instance] en el test - mismo doble que ya
/// usa `valoracion_encuesta_test.dart` para "Revise los detalles".
class _UrlLauncherFalso extends UrlLauncherPlatform {
  String? urlLanzada;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    urlLanzada = url;
    return true;
  }
}

/// Doble de [NotificacionesRepository] en memoria - sin red real. `lanzarAl`
/// simula una falla puntual (ej. `borrarUna` fallando) sin tocar el resto
/// de métodos.
class _FakeNotificacionesRepository implements NotificacionesRepository {
  _FakeNotificacionesRepository({List<NotificacionRecibida>? iniciales})
      : _notificaciones = List.of(iniciales ?? const []);

  List<NotificacionRecibida> _notificaciones;
  bool lanzarAlListar = false;
  bool lanzarAlBorrarUna = false;

  final List<String> llamadasBorrarUna = [];
  int llamadasBorrarTodas = 0;

  @override
  Future<List<NotificacionRecibida>> listarMisNotificaciones() async {
    if (lanzarAlListar) throw Exception('fallo de red simulado');
    return List.of(_notificaciones);
  }

  @override
  Future<void> borrarTodas() async {
    llamadasBorrarTodas++;
    _notificaciones = [];
  }

  @override
  Future<void> borrarUna(String idEnvio) async {
    llamadasBorrarUna.add(idEnvio);
    if (lanzarAlBorrarUna) throw Exception('fallo de red simulado');
    _notificaciones = _notificaciones.where((n) => n.id != idEnvio).toList();
  }

  @override
  Future<void> marcarLeido(String idNotificacion) async {}

  @override
  Future<void> registrarDeviceToken({
    required String token,
    required String plataforma,
  }) async {}
}

Future<void> _montar(
  WidgetTester tester,
  NotificacionesRepository repository,
) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(home: NotificationsScreen(repository: repository)),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('muestra las notificaciones reales agrupadas por fecha', (
    tester,
  ) async {
    final repo = _FakeNotificacionesRepository(
      iniciales: [_item('1'), _item('2')],
    );
    await _montar(tester, repo);

    expect(find.byType(NotificationItem), findsNWidgets(2));
    expect(find.text('Hoy'), findsOneWidget);
  });

  testWidgets('sin notificaciones, muestra el estado vacío', (tester) async {
    await _montar(tester, _FakeNotificacionesRepository());

    expect(find.byType(EmptyNotifications), findsOneWidget);
    expect(find.byType(NotificationItem), findsNothing);
  });

  testWidgets('error al cargar muestra el mensaje y "Reintentar" recarga', (
    tester,
  ) async {
    final repo = _FakeNotificacionesRepository(iniciales: [_item('1')])
      ..lanzarAlListar = true;
    await _montar(tester, repo);

    expect(
      find.text('No se pudieron cargar las notificaciones. Intenta de nuevo.'),
      findsOneWidget,
    );
    expect(find.byType(NotificationItem), findsNothing);

    repo.lanzarAlListar = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();

    expect(find.byType(NotificationItem), findsOneWidget);
  });

  testWidgets('"Borrar todo" llama al backend y vacía la lista', (
    tester,
  ) async {
    final repo = _FakeNotificacionesRepository(
      iniciales: [_item('1'), _item('2')],
    );
    await _montar(tester, repo);

    await tester.tap(find.text('Borrar todo'));
    await tester.pumpAndSettle();

    expect(repo.llamadasBorrarTodas, 1);
    expect(find.byType(EmptyNotifications), findsOneWidget);
  });

  testWidgets('deslizar un ítem lo borra en el backend', (tester) async {
    final repo = _FakeNotificacionesRepository(iniciales: [_item('1')]);
    await _montar(tester, repo);

    await tester.drag(find.byType(NotificationItem), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(repo.llamadasBorrarUna, ['1']);
    expect(find.byType(NotificationItem), findsNothing);
  });

  testWidgets('"Revise los detalles" abre el enlace de la notificación', (
    tester,
  ) async {
    final urlLauncherFalso = _UrlLauncherFalso();
    final original = UrlLauncherPlatform.instance;
    UrlLauncherPlatform.instance = urlLauncherFalso;
    addTearDown(() => UrlLauncherPlatform.instance = original);

    final repo = _FakeNotificacionesRepository(
      iniciales: [_item('1', accionRuta: 'https://esri.co/evento-x')],
    );
    await _montar(tester, repo);

    await tester.tap(find.text('Revise los detalles'));
    await tester.pumpAndSettle();

    expect(urlLauncherFalso.urlLanzada, 'https://esri.co/evento-x');
  });

  testWidgets('sin enlace propio, "Revise los detalles" queda deshabilitado', (
    tester,
  ) async {
    final urlLauncherFalso = _UrlLauncherFalso();
    final original = UrlLauncherPlatform.instance;
    UrlLauncherPlatform.instance = urlLauncherFalso;
    addTearDown(() => UrlLauncherPlatform.instance = original);

    final repo = _FakeNotificacionesRepository(iniciales: [_item('1')]);
    await _montar(tester, repo);

    await tester.tap(find.text('Revise los detalles'));
    await tester.pumpAndSettle();

    expect(urlLauncherFalso.urlLanzada, isNull);
  });
}
