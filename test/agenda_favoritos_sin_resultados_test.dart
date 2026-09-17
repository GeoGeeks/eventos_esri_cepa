import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';

import 'fuentes_de_prueba.dart';

/// Antes, una búsqueda/filtro que no dejaba ninguna actividad visible
/// dejaba la lista completamente en blanco, sin ningún mensaje - reporte
/// del usuario 2026-09-18, con screenshot.
Future<void> _montar(WidgetTester tester, Widget pantalla) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pump();
}

void main() {
  setUpAll(cargarFuentesReales);

  testWidgets(
    'Agenda: una búsqueda sin resultados muestra el mensaje, no una lista en blanco',
    (tester) async {
      await _montar(tester, const AgendaScreen());

      await tester.enterText(
        find.byType(TextField),
        'esto no coincide con ninguna actividad mock',
      );
      await tester.pump();

      expect(find.byType(ActividadCard), findsNothing);
      expect(
        find.text('No hay actividades para el filtro seleccionado'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Favoritos: una búsqueda sin resultados muestra el mensaje, no una lista en blanco',
    (tester) async {
      await _montar(tester, const FavoritosScreen());

      await tester.enterText(
        find.byType(TextField),
        'esto no coincide con ningún favorito mock',
      );
      await tester.pump();

      expect(find.byType(ActividadCard), findsNothing);
      expect(
        find.text('No hay actividades para el filtro seleccionado'),
        findsOneWidget,
      );
    },
  );
}
