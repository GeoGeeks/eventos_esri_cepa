import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/constants/icons.dart';
import 'package:esri_eventos/core/widgets/app_icons.dart';
import 'package:esri_eventos/core/widgets/etiqueta_chip.dart';
import 'package:esri_eventos/features/agenda/data/agenda_mock_data.dart';
import 'package:esri_eventos/features/agenda/data/charla.dart';
import 'package:esri_eventos/features/agenda/data/catalogo_item.dart';
import 'package:esri_eventos/features/agenda/data/laboratorio.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';

import 'fuentes_de_prueba.dart';

/// La Charla/Laboratorio reales no siempre traen ponente/aforo/lugar (ver
/// el doc-comment de `Charla`) - antes la tarjeta igual pintaba el ícono
/// solo, sin texto al lado, y un chip vacío se veía como un círculo azul
/// sin nada dentro. Corregido 2026-09-18 a pedido del usuario, con
/// screenshots de la app real.
Future<void> _montar(WidgetTester tester, Widget hijo) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: hijo)));
  await tester.pump();
}

/// `AppIcon` envuelve un SVG por ruta (`String`), no un `IconData` de
/// Material - `find.byIcon` no sirve aquí.
Finder _icono(String ruta) =>
    find.byWidgetPredicate((w) => w is AppIcon && w.icon == ruta);

void main() {
  setUpAll(cargarFuentesReales);

  group('ActividadCard oculta campos sin dato', () {
    testWidgets('sin ponente, no pinta el ícono de perfil ni deja hueco', (
      tester,
    ) async {
      const actividad = Actividad(
        titulo: 'Plenaria',
        horario: '08:00 - 10:00',
        ponente: '',
        lugar: 'Piso 5',
        aforo: '',
        etiquetas: ['Básico'],
        descripcion: '',
      );
      await _montar(
        tester,
        ActividadCard(
          actividad: actividad,
          expandida: false,
          onExpandir: () {},
          onValorar: () {},
        ),
      );

      expect(_icono(SvgIcon.perfil), findsNothing);
      // "Valorar" se sigue viendo aunque no haya ponente.
      expect(find.text('Valorar'), findsOneWidget);
      // Lugar sí tiene dato: su ícono se sigue pintando.
      expect(_icono(SvgIcon.lugar), findsOneWidget);
      // Aforo no tiene dato: su ícono no se pinta.
      expect(_icono(SvgIcon.aforo), findsNothing);
    });

    testWidgets('con los tres datos, los tres íconos se pintan', (
      tester,
    ) async {
      await _montar(
        tester,
        ActividadCard(
          actividad: AgendaMockData.actividades.first,
          expandida: false,
          onExpandir: () {},
          onValorar: () {},
        ),
      );

      expect(_icono(SvgIcon.perfil), findsOneWidget);
      expect(_icono(SvgIcon.lugar), findsOneWidget);
      expect(_icono(SvgIcon.aforo), findsOneWidget);
    });
  });

  group('Charla/Laboratorio.etiquetas descarta valores vacíos', () {
    test('Charla.etiquetas nunca incluye un valor en blanco', () {
      final charla = Charla(
        id: 'c1',
        idEvento: 'evt-1',
        nombre: 'Plenaria',
        fecha: DateTime(2026, 10, 1),
        horaInicio: DateTime(2026, 10, 1, 8),
        horaFin: DateTime(2026, 10, 1, 10),
        visibilidad: 'publica',
        tematicas: const [CatalogoItem(id: 1, valor: '', valorNormalizado: '')],
        productosEsri: const [
          CatalogoItem(id: 2, valor: '  ', valorNormalizado: ''),
        ],
        nivelesSesion: const [
          CatalogoItem(id: 3, valor: 'Basico', valorNormalizado: 'basico'),
        ],
      );

      expect(charla.etiquetas, ['Basico']);
    });

    test('Laboratorio.etiquetas nunca incluye un valor en blanco', () {
      final laboratorio = Laboratorio(
        id: 'l1',
        idEvento: 'evt-1',
        nombre: 'Taller',
        fecha: DateTime(2026, 10, 2),
        horaInicio: DateTime(2026, 10, 2, 14),
        horaFin: DateTime(2026, 10, 2, 15),
        tematicas: const [CatalogoItem(id: 1, valor: '', valorNormalizado: '')],
      );

      expect(laboratorio.etiquetas, isEmpty);
    });
  });

  testWidgets('EtiquetaChip vacío no se cuela en una fila real', (
    tester,
  ) async {
    // Documenta el síntoma visual reportado (círculo azul vacío): con la
    // lista ya filtrada por el getter, un chip sin texto no debería
    // aparecer nunca en pantalla.
    await _montar(
      tester,
      Row(
        children: const [
          EtiquetaChip(texto: 'Básico'),
        ],
      ),
    );

    expect(find.text(''), findsNothing);
    expect(find.text('Básico'), findsOneWidget);
  });
}
