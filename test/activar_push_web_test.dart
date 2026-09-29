import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/notificaciones/data/push_notificaciones_service.dart';
import 'package:esri_eventos/features/notificaciones/presentation/activar_push_web.dart';

class _PushFalso extends Mock implements PushNotificacionesService {}

Future<void> _montar(
  WidgetTester tester,
  _PushFalso push, {
  bool disponible = true,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ActivarPushWeb(push: push, disponible: disponible),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  late _PushFalso push;

  setUp(() => push = _PushFalso());

  testWidgets(
    'en Android/iOS nativos (push web no disponible) no ocupa espacio',
    (tester) async {
      await _montar(tester, push, disponible: false);

      expect(find.byKey(const Key('activar-push-web')), findsNothing);
      verifyNever(() => push.permisoWeb());
    },
  );

  testWidgets('con el permiso sin decidir ofrece activar', (tester) async {
    when(
      () => push.permisoWeb(),
    ).thenAnswer((_) async => AuthorizationStatus.notDetermined);

    await _montar(tester, push);

    expect(find.text('Activar notificaciones'), findsOneWidget);
  });

  testWidgets('si ya estan activas no muestra nada', (tester) async {
    when(
      () => push.permisoWeb(),
    ).thenAnswer((_) async => AuthorizationStatus.authorized);

    await _montar(tester, push);

    expect(find.byKey(const Key('activar-push-web')), findsNothing);
  });

  testWidgets('al tocar activa, confirma y desaparece la tarjeta', (
    tester,
  ) async {
    when(
      () => push.permisoWeb(),
    ).thenAnswer((_) async => AuthorizationStatus.notDetermined);
    when(() => push.activarEnWeb()).thenAnswer((_) async => true);

    await _montar(tester, push);
    await tester.tap(find.text('Activar notificaciones'));
    await tester.pump();
    await tester.pump();

    verify(() => push.activarEnWeb()).called(1);
    expect(
      find.text(
        'Listo: recibirá las notificaciones del evento en este dispositivo.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('activar-push-web')), findsNothing);
  });

  testWidgets('bloqueadas en el navegador: explica y no ofrece el botón', (
    tester,
  ) async {
    when(
      () => push.permisoWeb(),
    ).thenAnswer((_) async => AuthorizationStatus.denied);

    await _montar(tester, push);

    expect(find.byKey(const Key('activar-push-web')), findsOneWidget);
    expect(find.text('Activar notificaciones'), findsNothing);
  });
}
