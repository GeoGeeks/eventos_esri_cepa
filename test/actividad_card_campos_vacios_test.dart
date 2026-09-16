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
  // `SingleChildScrollView` (no `body: hijo` a secas) para que el widget
  // reciba altura SIN LÍMITE y se mida por su propio contenido - `Column`
  // usa `mainAxisSize.max` por defecto, así que con la altura acotada que
  // da `Scaffold` (los 600 del viewport de prueba) se estiraba a llenarla
  // sin importar el contenido, y las dos tarjetas del test de abajo
  // medían lo mismo.
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: SingleChildScrollView(child: hijo))),
  );
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

    testWidgets(
      'con datos incompletos, el hueco antes de las etiquetas se achica',
      (tester) async {
        // Mismo título/horario/lugar en las dos para que la única
        // diferencia de alto sea el hueco fijo antes de las etiquetas, no
        // el número de líneas de texto.
        const completa = Actividad(
          titulo: 'Plenaria',
          horario: '08:00 - 10:00',
          ponente: 'Julian Gutiérrez',
          lugar: 'Piso 5',
          aforo: 'Aforo 30 personas',
          etiquetas: ['Basico'],
          descripcion: '',
        );
        const incompleta = Actividad(
          titulo: 'Plenaria',
          horario: '08:00 - 10:00',
          ponente: '',
          lugar: 'Piso 5',
          aforo: '',
          etiquetas: ['Basico'],
          descripcion: '',
        );

        await _montar(
          tester,
          ActividadCard(
            actividad: completa,
            expandida: false,
            onExpandir: () {},
            onValorar: () {},
          ),
        );
        final altoCompleta = tester
            .getRect(find.byType(ActividadCard))
            .height;

        await _montar(
          tester,
          ActividadCard(
            actividad: incompleta,
            expandida: false,
            onExpandir: () {},
            onValorar: () {},
          ),
        );
        final altoIncompleta = tester
            .getRect(find.byType(ActividadCard))
            .height;

        // Sin aforo desaparece esa fila entera (16 + 2 de separación) y el
        // hueco fijo baja de 10 a 6 - la tarjeta incompleta debe quedar
        // notablemente más baja, no solo unos décimos de píxel.
        expect(altoIncompleta, lessThan(altoCompleta - 15));
      },
    );
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
