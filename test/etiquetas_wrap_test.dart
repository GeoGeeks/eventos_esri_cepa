import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/etiqueta_chip.dart';
import 'package:esri_eventos/features/agenda/data/agenda_mock_data.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/invitados/data/invitados_mock_data.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';

import 'fuentes_de_prueba.dart';

/// Reporte del usuario 2026-09-18 (con screenshot de un `RenderFlex
/// overflowed`): con varias etiquetas reales (temática + producto + nivel
/// juntos, más de lo que el mock siempre tuvo) la fila de chips
/// desbordaba en vez de pasar a la siguiente línea.
void main() {
  setUpAll(cargarFuentesReales);

  Future<void> montar(WidgetTester tester, Widget hijo) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(MaterialApp(home: hijo));
    await tester.pump();
  }

  const etiquetasLargas = [
    'Gemelos Digitales',
    'BIM 3D',
    'ArcGIS Pro',
    'Administración ArcGIS Enterprise',
    'Online',
  ];

  testWidgets('ActividadCard: muchas etiquetas pasan a otra línea, sin desbordar', (
    tester,
  ) async {
    final actividad = Actividad(
      titulo: 'Explora modelos digitales aplicado BIM en ArcGIS Pro',
      horario: '2:00 p.m.',
      ponente: '',
      lugar: 'Piso 2 - Salón EFG',
      aforo: '',
      etiquetas: etiquetasLargas,
      descripcion: '',
    );

    await montar(
      tester,
      Scaffold(
        body: ActividadCard(
          actividad: actividad,
          expandida: false,
          onExpandir: () {},
          onValorar: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(EtiquetaChip), findsNWidgets(etiquetasLargas.length));

    // Con 5 etiquetas largas, no caben en una sola línea - confirma que sí
    // hay una segunda línea (si desbordara en vez de envolver, todos los
    // chips seguirían compartiendo la misma `top`).
    final tops = [
      for (var i = 0; i < etiquetasLargas.length; i++)
        tester.getRect(find.byType(EtiquetaChip).at(i)).top,
    ];
    expect(tops.toSet().length, greaterThan(1));
  });

  testWidgets('SesionCard: muchas etiquetas pasan a otra línea, sin desbordar', (
    tester,
  ) async {
    final sesion = SesionEvento(
      titulo: 'Explora modelos digitales aplicado BIM en ArcGIS Pro',
      fecha: 'Oct 01 - 2:00 p.m.',
      lugar: 'Piso 2 - Salón EFG',
      etiquetas: etiquetasLargas,
    );

    await montar(
      tester,
      Scaffold(
        body: SesionCard(sesion: sesion, expandida: true),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(EtiquetaChip), findsNWidgets(etiquetasLargas.length));

    final tops = [
      for (var i = 0; i < etiquetasLargas.length; i++)
        tester.getRect(find.byType(EtiquetaChip).at(i)).top,
    ];
    expect(tops.toSet().length, greaterThan(1));
  });
}
