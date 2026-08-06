import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/login/login_screen.dart';
import 'package:esri_eventos/features/login/soporte_screen.dart';
import 'package:esri_eventos/features/login/verificacion_screen.dart';

import 'fuentes_de_prueba.dart';

/// Tamaños reales: el del diseño y el del emulador (411,43 dp, no 412).
const List<Size> _lienzos = [Size(412, 917), Size(1080 / 2.625, 869)];

Future<void> _montar(WidgetTester tester, Widget pantalla, Size lienzo) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  // Plataforma Android explícita: es la única en la que Material envuelve el
  // scroll en el indicador que estira, así que sin fijarla el test no probaría
  // nada en un equipo que no sea Android.
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: TargetPlatform.android),
      home: pantalla,
    ),
  );
  await tester.pumpAndSettle();
}

ScrollPhysics _fisica(WidgetTester tester) => tester
    .state<ScrollableState>(find.byType(Scrollable).first)
    .position
    .physics;

/// Las tres pantallas que monta `FondoInicio`.
final Map<String, Widget Function()> _pantallas = {
  'Iniciar Sesión': () => const LoginScreen(),
  'Verificación': () => const VerificacionScreen(),
  'Soporte': () => const SoporteScreen(),
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  // Testigo: un scroll cualquiera, con el comportamiento por defecto, sí monta
  // el indicador que estira. Si este caso dejara de pasar, los de abajo
  // estarían dando verde sin probar nada.
  testWidgets('sin el comportamiento propio, Material sí estira', (
    tester,
  ) async {
    await _montar(
      tester,
      const SingleChildScrollView(child: SizedBox(height: 2000)),
      const Size(412, 917),
    );

    expect(find.byType(StretchingOverscrollIndicator), findsOneWidget);
  });

  _pantallas.forEach((nombre, construir) {
    for (final lienzo in _lienzos) {
      testWidgets('$nombre no estira el contenido al sobre-arrastrar '
          '($lienzo)', (tester) async {
        await _montar(tester, construir(), lienzo);

        // El indicador de Android que deforma el contenido no debe montarse.
        expect(find.byType(StretchingOverscrollIndicator), findsNothing);
        expect(find.byType(GlowingOverscrollIndicator), findsNothing);

        expect(_fisica(tester), isA<ClampingScrollPhysics>());
      });

      testWidgets('$nombre sigue desplazándose ($lienzo)', (tester) async {
        await _montar(tester, construir(), lienzo);

        final logo = find.text('Eventos Esri');
        final antes = tester.getRect(logo).top;

        await tester.drag(find.byType(Scrollable).first, const Offset(0, -80));
        await tester.pumpAndSettle();

        // Si sobra contenido, el arrastre lo sube; si cabe entero, no se mueve.
        expect(tester.getRect(logo).top, lessThanOrEqualTo(antes));
        expect(tester.takeException(), isNull);
      });

      testWidgets('$nombre: el sobre-arrastre no deja el contenido movido '
          '($lienzo)', (tester) async {
        await _montar(tester, construir(), lienzo);

        final logo = find.text('Eventos Esri');
        final antes = tester.getRect(logo);

        // Arrastre hacia abajo estando ya en el tope: es el gesto que antes
        // deformaba la tarjeta, el logo y el título.
        final gesto = await tester.startGesture(
          tester.getCenter(find.byType(Scrollable).first),
        );
        await gesto.moveBy(const Offset(0, 200));
        await tester.pump();

        expect(tester.getRect(logo), antes);

        await gesto.up();
        await tester.pumpAndSettle();

        expect(tester.getRect(logo), antes);
      });
    }
  });
}
