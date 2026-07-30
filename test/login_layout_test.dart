import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/login/login_screen.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montarLogin(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('logo, título y panel caen donde los pone Figma', (tester) async {
    await _montarLogin(tester);

    final logo = tester.getRect(find.byType(SvgPicture).first);
    expect(logo.top, moreOrLessEquals(160, epsilon: 0.5));
    expect(logo.width, moreOrLessEquals(65, epsilon: 0.5));
    expect(logo.height, moreOrLessEquals(74, epsilon: 0.5));
    expect(logo.center.dx, moreOrLessEquals(206, epsilon: 0.5));

    final titulo = tester.getRect(find.text('Eventos Esri'));
    expect(titulo.top, moreOrLessEquals(254, epsilon: 0.5));
    expect(titulo.height, moreOrLessEquals(48, epsilon: 0.5));

    final panel = tester.getRect(
      find
          .ancestor(
            of: find.text('Iniciar Sesión'),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(panel.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(panel.top, moreOrLessEquals(334, epsilon: 0.5));
    expect(panel.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(panel.height, moreOrLessEquals(308, epsilon: 0.5));
  });

  testWidgets('campo y botón miden 288x44', (tester) async {
    await _montarLogin(tester);

    // El marco del campo, no el TextField interno: el borde de 1 px se dibuja
    // por dentro, así que al texto le quedan 214 de los 216 de Figma.
    final campo = tester.getRect(
      find
          .ancestor(
            of: find.byType(TextField),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(campo.width, moreOrLessEquals(288, epsilon: 0.5));
    expect(campo.height, moreOrLessEquals(44, epsilon: 0.5));

    final boton = tester.getRect(find.byType(ElevatedButton));
    expect(boton.width, moreOrLessEquals(288, epsilon: 0.5));
    expect(boton.height, moreOrLessEquals(44, epsilon: 0.5));
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarLogin(tester);
    expect(tester.takeException(), isNull);
  });
}
