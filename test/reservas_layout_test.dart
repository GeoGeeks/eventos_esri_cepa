import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/upcoming_event_card.dart';
import 'package:esri_eventos/features/reservas/reservas_screen.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montarReservas(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: ReservasScreen()));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('título y subtítulo caen donde los pone Figma', (tester) async {
    await _montarReservas(tester);

    final titulo = tester.getRect(find.text('Eventos Reservados'));
    expect(titulo.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(titulo.top, moreOrLessEquals(36, epsilon: 0.5));
    expect(titulo.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(titulo.height, moreOrLessEquals(32, epsilon: 0.5));

    final subtitulo = tester.getRect(
      find.text(
        'Encuentre la información sobre los eventos en '
        'los que se ha registrado.',
      ),
    );
    expect(subtitulo.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(subtitulo.top, moreOrLessEquals(82, epsilon: 0.5));
    expect(subtitulo.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(subtitulo.height, moreOrLessEquals(40, epsilon: 0.5));
  });

  testWidgets('buscador y split button miden 32 de alto y arrancan en 148',
      (tester) async {
    await _montarReservas(tester);

    final buscador = tester.getRect(find.byType(TextField));
    expect(buscador.top, moreOrLessEquals(148, epsilon: 0.5));
    expect(buscador.height, moreOrLessEquals(32, epsilon: 0.5));

    final split = tester.getRect(find.byType(Row).at(0));
    expect(split.top, moreOrLessEquals(148, epsilon: 0.5));
    expect(split.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(split.height, moreOrLessEquals(32, epsilon: 0.5));
  });

  testWidgets('cada card mide 360x122 y separa 24', (tester) async {
    await _montarReservas(tester);

    final cards = find.byType(UpcomingEventCard);
    expect(cards, findsNWidgets(2));

    final primera = tester.getRect(cards.at(0));
    expect(primera.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(primera.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(primera.height, moreOrLessEquals(122, epsilon: 0.5));
    expect(primera.top, moreOrLessEquals(204, epsilon: 0.5));

    final segunda = tester.getRect(cards.at(1));
    expect(segunda.height, moreOrLessEquals(122, epsilon: 0.5));
    expect(segunda.top - primera.bottom, moreOrLessEquals(24, epsilon: 0.5));
  });

  testWidgets('el segundo botón dice "Mi credencial", no "Registrarse"',
      (tester) async {
    await _montarReservas(tester);

    expect(find.text('Mi credencial'), findsNWidgets(2));
    expect(find.text('Registrarse'), findsNothing);

    final verMas = tester.getRect(find.text('Ver más').first);
    final credencial = tester.getRect(find.text('Mi credencial').first);
    expect(credencial.left - verMas.right, moreOrLessEquals(35, epsilon: 2));
  });

  testWidgets('el filtro se abre y filtra por modalidad', (tester) async {
    await _montarReservas(tester);

    expect(find.text('Modalidad'), findsNothing);

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();
    expect(find.text('Modalidad'), findsOneWidget);

    await tester.tap(find.text('Virtual'));
    await tester.pump();
    expect(find.text('No se encontraron eventos'), findsOneWidget);

    await tester.tap(find.text('Presencial').first);
    await tester.pump();
    expect(find.text('CUE 2026'), findsOneWidget);
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarReservas(tester);
    expect(tester.takeException(), isNull);
  });
}
