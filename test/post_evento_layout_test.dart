import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/post_evento/data/valoracion_store.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';

import 'fuentes_de_prueba.dart';

/// Ancho real del emulador: 1080 px físicos a densidad 2,625 (ver D26).
const double _anchoEmulador = 1080 / 2.625;

const _lienzos = [
  Size(412, 917),
  Size(_anchoEmulador, 869),
  Size(360, 800),
];

Future<void> _montar(WidgetTester tester, Size lienzo) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: PostEventoScreen(onBack: () {})));
  await tester.pump();
}

Future<void> _irA(WidgetTester tester, String pestana) async {
  await tester.tap(find.text(pestana));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  setUp(() => ValoracionStore.eventoValorado.value = false);
  tearDown(() => ValoracionStore.eventoValorado.value = false);

  for (final lienzo in _lienzos) {
    group('a $lienzo', () {
      // El defecto: «Agendar con expertos» trae mucho menos contenido que
      // «Galería», y con el `Center` que envolvía al scroll la vista se
      // encogía a su contenido y quedaba centrada verticalmente, así que al
      // cambiar de pestaña bajaba el bloque entero. La cabecera del panel
      // —fecha, botones y pestañas— tiene que quedarse donde estaba.
      testWidgets('la cabecera del panel no se mueve al cambiar de pestaña', (
        tester,
      ) async {
        await _montar(tester, lienzo);

        final fechaGaleria = tester.getRect(find.text('Octubre 02, 2026'));
        final botonesGaleria = tester.getRect(
          find.byKey(const Key('post-evento-valorar')),
        );
        final tabsGaleria = tester.getRect(find.text('Galería'));

        await _irA(tester, 'Agendar con expertos');

        expect(tester.getRect(find.text('Octubre 02, 2026')), fechaGaleria);
        expect(
          tester.getRect(find.byKey(const Key('post-evento-valorar'))),
          botonesGaleria,
        );
        expect(tester.getRect(find.text('Galería')), tabsGaleria);

        // Y al volver, tampoco.
        await _irA(tester, 'Galería');
        expect(tester.getRect(find.text('Octubre 02, 2026')), fechaGaleria);
      });

      testWidgets('el panel arranca en 96 y la fecha en 122, como Invitados', (
        tester,
      ) async {
        await _montar(tester, lienzo);

        // 96 del panel + 26 de aire interior = 122, la misma `y` de Figma.
        expect(
          tester.getRect(find.text('Octubre 02, 2026')).top,
          moreOrLessEquals(122, epsilon: 1),
        );
      });

      testWidgets('las dos pestañas comparten la columna de 360', (
        tester,
      ) async {
        await _montar(tester, lienzo);

        final ancho = lienzo.width;
        final columna = ancho < 360 ? ancho : 360.0;

        // Galería: la rejilla ocupa la columna completa.
        final galeria = tester.getRect(find.byType(GridView));
        expect(galeria.width, moreOrLessEquals(columna, epsilon: 0.5));

        await _irA(tester, 'Agendar con expertos');

        // Expertos: las tarjetas arrancan en la misma `x` que la rejilla.
        final tarjeta = tester.getRect(find.text('Edwin Chirivi'));
        expect(tarjeta.left, greaterThanOrEqualTo(galeria.left));
      });

      testWidgets('ninguna de las dos pestañas desborda', (tester) async {
        await _montar(tester, lienzo);
        expect(tester.takeException(), isNull);

        await _irA(tester, 'Agendar con expertos');
        expect(tester.takeException(), isNull);

        await _irA(tester, 'Galería');
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets('el contenido de cada pestaña sigue siendo el suyo', (
    tester,
  ) async {
    await _montar(tester, const Size(412, 917));

    // Galería: rejilla de fotos, sin tarjetas de expertos.
    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Edwin Chirivi'), findsNothing);

    await _irA(tester, 'Agendar con expertos');

    // Expertos: sus dos tarjetas, sin rejilla.
    expect(find.byType(GridView), findsNothing);
    expect(find.text('Edwin Chirivi'), findsOneWidget);
    expect(find.text('María Fernanda Ruiz'), findsOneWidget);
    expect(find.text('Agendar'), findsNWidgets(2));
  });
}
