import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/profile/data/preguntas_frecuentes_data.dart';
import 'package:esri_eventos/features/profile/presentation/screens/preguntas_frecuentes_screen.dart';
import 'package:esri_eventos/features/profile/presentation/screens/profile_menu_screen.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montar(
  WidgetTester tester, {
  VoidCallback? onBack,
  VoidCallback? onContactar,
}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PreguntasFrecuentesScreen(
          onBack: onBack ?? () {},
          onContactar: onContactar ?? () {},
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  test('trae las 10 preguntas de la PO en 2 categorías', () {
    final categorias = PreguntasFrecuentesData.categorias;
    expect(categorias.map((c) => c.titulo), [
      'Información general',
      'Acerca de mis eventos',
    ]);
    expect(categorias.expand((c) => c.preguntas), hasLength(10));
  });

  testWidgets('muestra título, categorías y preguntas cerradas', (
    tester,
  ) async {
    await _montar(tester);

    expect(find.text('Preguntas frecuentes'), findsOneWidget);
    expect(find.text('Información general'), findsOneWidget);
    expect(find.text('¿Cómo crear una cuenta?'), findsOneWidget);
    expect(
      find.textContaining('Sus datos personales se actualizan'),
      findsNothing,
    );
  });

  testWidgets('tocar una pregunta muestra su respuesta y cierra la anterior', (
    tester,
  ) async {
    await _montar(tester);

    await tester.tap(find.text('¿Cómo actualizar mis datos personales?'));
    await tester.pump();
    expect(
      find.textContaining('Sus datos personales se actualizan'),
      findsOneWidget,
    );

    await tester.tap(find.text('¿Cuáles son mis eventos reservados?'));
    await tester.pump();
    expect(
      find.textContaining('Sus datos personales se actualizan'),
      findsNothing,
    );
    expect(
      find.textContaining('todos los eventos en los que está registrado'),
      findsOneWidget,
    );

    // Volver a tocar la abierta la cierra.
    await tester.tap(find.text('¿Cuáles son mis eventos reservados?'));
    await tester.pump();
    expect(
      find.textContaining('todos los eventos en los que está registrado'),
      findsNothing,
    );
  });

  testWidgets('la respuesta de "crear una cuenta" enlaza a privacidad', (
    tester,
  ) async {
    await _montar(tester);

    await tester.tap(find.text('¿Cómo crear una cuenta?'));
    await tester.pump();

    final texto = tester.widget<Text>(
      find.textContaining('No es necesario crear una cuenta'),
    );
    final enlace = (texto.textSpan! as TextSpan).children!
        .cast<TextSpan>()
        .firstWhere((s) => s.recognizer != null);
    expect(enlace.text, 'aquí');
    expect(
      PreguntasFrecuentesData.urlPrivacidad,
      'https://www.esri.co/es-co/privacidad',
    );
  });

  testWidgets('los botones de la cabecera vuelven y abren Contáctenos', (
    tester,
  ) async {
    var volvio = false;
    var contacto = false;
    await _montar(
      tester,
      onBack: () => volvio = true,
      onContactar: () => contacto = true,
    );

    await tester.tap(find.byKey(const Key('faq-volver')));
    await tester.tap(find.byKey(const Key('faq-contactar')));

    expect(volvio, isTrue);
    expect(contacto, isTrue);
  });

  test('Contáctenos es un correo a vpiravaguen@esri.co con asunto', () {
    final uri = ProfileMenuScreen.mailtoContacto;
    expect(uri.scheme, 'mailto');
    expect(uri.path, 'vpiravaguen@esri.co');
    expect(uri.toString(), isNot(contains('+')));
    expect(
      Uri.decodeComponent(uri.query),
      'subject=Contacto - App Eventos Esri Colombia',
    );
  });
}
