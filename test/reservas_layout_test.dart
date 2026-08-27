import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/constants/app_colors.dart';
import 'package:esri_eventos/core/constants/icons.dart';
import 'package:esri_eventos/core/widgets/casilla_verificacion.dart';
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
    // Hoy solo hay un evento reservado; el recorrido sigue valiendo si se
    // añaden más, así que no se fija el número de tarjetas.
    final total = cards.evaluate().length;
    expect(total, greaterThanOrEqualTo(1));

    Rect? anterior;
    for (var i = 0; i < total; i++) {
      final card = tester.getRect(cards.at(i));
      expect(card.left, moreOrLessEquals(26, epsilon: 0.5));
      expect(card.width, moreOrLessEquals(360, epsilon: 0.5));
      expect(card.height, moreOrLessEquals(122, epsilon: 0.5));
      if (anterior == null) {
        expect(card.top, moreOrLessEquals(204, epsilon: 0.5));
      } else {
        expect(card.top - anterior.bottom, moreOrLessEquals(24, epsilon: 0.5));
      }
      anterior = card;
    }
  });

  testWidgets('el segundo botón dice "Mi credencial", no "Registrarse"',
      (tester) async {
    await _montarReservas(tester);

    // Una etiqueta por tarjeta, sean las que sean.
    final cards = find.byType(UpcomingEventCard).evaluate().length;
    expect(find.text('Mi credencial'), findsNWidgets(cards));
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

  testWidgets('"Mi credencial" abre el modal de credencial', (tester) async {
    await _montarReservas(tester);

    expect(find.text('Credencial digital'), findsNothing);

    await tester.tap(find.text('Mi credencial').first);
    await tester.pumpAndSettle();

    expect(find.text('Credencial digital'), findsOneWidget);
    expect(
      find.text('Utilice este código para acceder al evento'),
      findsOneWidget,
    );
  });

  testWidgets('las casillas de modalidad se marcan con el check SVG', (
    tester,
  ) async {
    await _montarReservas(tester);

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();

    final casilla = find.byType(CasillaVerificacion).first;
    expect(tester.widget<CasillaVerificacion>(casilla).marcada, isFalse);
    expect(
      find.descendant(of: casilla, matching: find.byType(SvgPicture)),
      findsNothing,
    );

    await tester.tap(find.text('Virtual'));
    await tester.pump();

    final marcada = tester.widget<CasillaVerificacion>(
      find.byType(CasillaVerificacion).first,
    );
    expect(marcada.marcada, isTrue);

    final icono = tester.widget<SvgPicture>(
      find.descendant(
        of: find.byType(CasillaVerificacion).first,
        matching: find.byType(SvgPicture),
      ),
    );
    expect((icono.bytesLoader as SvgAssetLoader).assetName, SvgIcon.check);
    expect(
      icono.colorFilter,
      const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
    );
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarReservas(tester);
    expect(tester.takeException(), isNull);
  });
}
