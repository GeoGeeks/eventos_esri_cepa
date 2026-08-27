import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/post_evento/data/valoracion_store.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';

import 'fuentes_de_prueba.dart';

const Color _azul = Color(0xFF007AC2);
const Color _gris = Color(0xFF949494);
const Color _blanco = Color(0xFFFFFFFF);
const Color _apagado = Color(0xFFF7F7F7);

Future<void> _montar(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: PostEventoScreen(onBack: () {})));
  await tester.pump();
}

/// Fondo, borde y color de la letra del botón [clave].
({Color fondo, Color? borde, Color texto}) _estilo(
  WidgetTester tester,
  String clave,
) {
  final caja = tester.widget<Container>(
    find
        .descendant(
          of: find.byKey(Key(clave)),
          matching: find.byType(Container),
        )
        .first,
  );
  final decoracion = caja.decoration! as BoxDecoration;
  final texto = tester.widget<Text>(
    find.descendant(of: find.byKey(Key(clave)), matching: find.byType(Text)),
  );
  return (
    fondo: decoracion.color!,
    borde: decoracion.border?.bottom.color,
    texto: texto.style!.color!,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  // El store es estático: cada prueba parte de «sin valorar».
  setUp(() => ValoracionStore.eventoValorado.value = false);
  tearDown(() => ValoracionStore.eventoValorado.value = false);

  testWidgets('sin valorar manda «Valorar evento» y el certificado no baja', (
    tester,
  ) async {
    await _montar(tester);

    final valorar = _estilo(tester, 'post-evento-valorar');
    expect(valorar.fondo, _azul);
    expect(valorar.texto, _blanco);
    expect(valorar.borde, isNull);

    final certificado = _estilo(tester, 'post-evento-certificado');
    expect(certificado.fondo, _apagado);
    expect(certificado.texto, _gris);
    expect(certificado.borde, _gris);

    // Apagado: pulsarlo no abre nada.
    await tester.tap(find.byKey(const Key('post-evento-certificado')));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(const Key('certificado-toast')), findsNothing);
  });

  testWidgets('al valorar se intercambian los dos botones', (tester) async {
    await _montar(tester);

    ValoracionStore.marcarValorado();
    await tester.pump();

    final valorar = _estilo(tester, 'post-evento-valorar');
    expect(valorar.fondo, _blanco);
    expect(valorar.texto, _gris);
    expect(valorar.borde, _gris);

    final certificado = _estilo(tester, 'post-evento-certificado');
    expect(certificado.fondo, _azul);
    expect(certificado.texto, _blanco);
    expect(certificado.borde, isNull);
  });

  testWidgets('el toast entra de derecha a izquierda y va 15 bajo los botones', (
    tester,
  ) async {
    await _montar(tester);
    ValoracionStore.marcarValorado();
    await tester.pump();

    final botones = tester.getRect(
      find.byKey(const Key('post-evento-certificado')),
    );

    await tester.tap(find.byKey(const Key('post-evento-certificado')));
    await tester.pump();

    // Nada más aparecer viene desde fuera, por la derecha: el desplazamiento
    // arranca en +1 ancho y termina en 0.
    final deslizamiento = find.descendant(
      of: find.byKey(const Key('certificado-toast')),
      matching: find.byType(SlideTransition),
    );
    expect(
      tester.widget<SlideTransition>(deslizamiento).position.value.dx,
      greaterThan(0.5),
    );

    await tester.pump(const Duration(milliseconds: 400));
    expect(
      tester.widget<SlideTransition>(deslizamiento).position.value,
      Offset.zero,
    );

    final asentado = tester.getRect(find.byKey(const Key('certificado-toast')));

    expect(find.text('¡Gracias por tu opinión!'), findsOneWidget);
    expect(find.text('Se ha descargado su certificado.'), findsOneWidget);

    expect(asentado.top - botones.bottom, moreOrLessEquals(15, epsilon: 0.5));
    // Ocupa la columna de 360 de la pantalla (el SVG lo dibuja a 361).
    expect(asentado.width, moreOrLessEquals(360, epsilon: 0.5));
  });
}
