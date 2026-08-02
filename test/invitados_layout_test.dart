import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/bottom_nav.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montarInvitados(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: InvitadosScreen()));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('la barra inferior de menú está presente', (tester) async {
    await _montarInvitados(tester);

    expect(find.byType(CustomBottomNav), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Reservas'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('cabecera 412x122 y botón de volver 36x36 en 36,26',
      (tester) async {
    await _montarInvitados(tester);

    final cabecera = tester.getRect(find.byType(Image).first);
    expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
    expect(cabecera.left, moreOrLessEquals(0, epsilon: 0.5));
    expect(cabecera.width, moreOrLessEquals(412, epsilon: 0.5));
    expect(cabecera.height, moreOrLessEquals(122, epsilon: 0.5));

    final volver = tester.getRect(find.byKey(const Key('invitados-volver')));
    expect(volver.top, moreOrLessEquals(36, epsilon: 0.5));
    expect(volver.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(volver.width, moreOrLessEquals(36, epsilon: 0.5));
    expect(volver.height, moreOrLessEquals(36, epsilon: 0.5));
  });

  testWidgets('las filas de datos arrancan en 122,26 con hueco de 5',
      (tester) async {
    await _montarInvitados(tester);

    final fecha = tester.getRect(find.text('Octubre 01, 2026'));
    final hora = tester.getRect(find.text('8:00 - 11:00'));
    final lugar =
        tester.getRect(find.text('Universidad Central Cra 36 # 24 – 45'));

    expect(fecha.left, moreOrLessEquals(50, epsilon: 0.5));
    expect(fecha.top, moreOrLessEquals(122, epsilon: 0.5));
    expect(fecha.height, moreOrLessEquals(24, epsilon: 0.5));

    expect(hora.top - fecha.bottom, moreOrLessEquals(5, epsilon: 0.5));
    expect(hora.height, moreOrLessEquals(24, epsilon: 0.5));

    expect(lugar.top - hora.bottom, moreOrLessEquals(5, epsilon: 0.5));
    expect(lugar.height, moreOrLessEquals(48, epsilon: 0.5));
  });

  testWidgets('la dirección larga fluye a 2 líneas en vez de cortarse',
      (tester) async {
    await _montarInvitados(tester);

    final texto = tester.widget<Text>(
      find.text('Universidad Central Cra 36 # 24 – 45'),
    );
    expect(texto.maxLines, isNull);
    expect(texto.overflow, isNot(TextOverflow.ellipsis));
  });

  testWidgets('el botón QR de 40x40 sigue a la derecha de los datos',
      (tester) async {
    await _montarInvitados(tester);

    final qr = tester.getRect(
      find.ancestor(
        of: find.byIcon(Icons.qr_code),
        matching: find.byType(Container),
      ).first,
    );
    expect(qr.width, moreOrLessEquals(40, epsilon: 0.5));
    expect(qr.height, moreOrLessEquals(40, epsilon: 0.5));
    expect(qr.right, moreOrLessEquals(386, epsilon: 0.5));
  });

  testWidgets('los botones miden 125x44 y 160x44', (tester) async {
    await _montarInvitados(tester);

    final agenda = tester.getRect(
      find.ancestor(of: find.text('Agenda'), matching: find.byType(Container))
          .first,
    );
    expect(agenda.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(agenda.width, moreOrLessEquals(125, epsilon: 0.5));
    expect(agenda.height, moreOrLessEquals(44, epsilon: 0.5));

    final favoritos = tester.getRect(
      find.ancestor(
        of: find.text('Mis Favoritos'),
        matching: find.byType(Container),
      ).first,
    );
    expect(favoritos.width, moreOrLessEquals(160, epsilon: 0.5));
    expect(favoritos.height, moreOrLessEquals(44, epsilon: 0.5));
    expect(favoritos.left - agenda.right, moreOrLessEquals(12, epsilon: 0.5));
  });

  testWidgets('el menú de pestañas mide 360x34 y arranca en left 26',
      (tester) async {
    await _montarInvitados(tester);

    final tabs = tester.getRect(find.byKey(const Key('invitados-tabs')));
    expect(tabs.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tabs.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tabs.height, moreOrLessEquals(34, epsilon: 0.5));
  });

  testWidgets('la flecha izquierda solo aparece al avanzar de pestaña',
      (tester) async {
    await _montarInvitados(tester);

    final tabs = tester.getRect(find.byKey(const Key('invitados-tabs')));

    final primeraPestana = tester.getRect(find.text('Speakers e Invitados'));
    expect(primeraPestana.left, moreOrLessEquals(tabs.left + 8, epsilon: 0.5));

    await tester.tap(find.text('Experiencias'));
    await tester.pump();

    final activa = tester.getRect(find.text('Experiencias'));
    expect(activa.left, greaterThan(tabs.left + 40));
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarInvitados(tester);
    expect(tester.takeException(), isNull);
  });
}
