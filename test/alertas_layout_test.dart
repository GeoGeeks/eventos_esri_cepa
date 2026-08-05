import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/alerta_modal.dart';
import 'package:esri_eventos/core/widgets/formulario_web_modal.dart';
import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montar(WidgetTester tester, Widget pantalla) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pump();
}

/// Envía la encuesta de la primera actividad visible.
Future<void> _valorarPrimera(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('actividad-valorar')).first);
  await tester.pumpAndSettle();

  final enviar = find.text('Enviar valoración');
  await tester.ensureVisible(enviar);
  await tester.pumpAndSettle();
  await tester.tap(enviar);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  group('alerta de valoración', () {
    testWidgets('sale al enviar la encuesta desde Agenda', (tester) async {
      await _montar(tester, const AgendaScreen());

      expect(find.byType(AlertaModal), findsNothing);
      await _valorarPrimera(tester);

      expect(find.byType(AlertaModal), findsOneWidget);
      expect(find.text('¡Gracias por su valoración!'), findsOneWidget);
      expect(
        find.textContaining('Hemos recibido sus comentarios'),
        findsOneWidget,
      );

      // Panel de 360 en y=397,5, según `Valoración_gracias.svg`.
      final panel = tester.getRect(find.byType(AlertaModal));
      expect(panel.width, moreOrLessEquals(360, epsilon: 0.5));
      expect(panel.top, moreOrLessEquals(397.5, epsilon: 1));

      await tester.tap(find.byKey(const Key('alerta-cerrar')));
      await tester.pumpAndSettle();
      expect(find.byType(AlertaModal), findsNothing);
    });

    testWidgets('en Favoritos «Valorar» se apaga tras valorar', (tester) async {
      await _montar(tester, const FavoritosScreen());

      final antes = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('actividad-valorar')).first,
          matching: find.text('Valorar'),
        ),
      );
      expect(antes.style!.color, isNot(Colors.transparent));

      await _valorarPrimera(tester);
      await tester.tap(find.byKey(const Key('alerta-cerrar')));
      await tester.pumpAndSettle();

      // La palabra deja de verse y la línea pasa de azul a #949494.
      final despues = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('actividad-valorar')).first,
          matching: find.text('Valorar'),
        ),
      );
      expect(despues.style!.color, Colors.transparent);

      final caja = tester.widget<Container>(
        find
            .descendant(
              of: find.byKey(const Key('actividad-valorar')).first,
              matching: find.byType(Container),
            )
            .first,
      );
      final borde = (caja.decoration! as BoxDecoration).border!.bottom;
      expect(borde.color, const Color(0xFF949494));
    });
  });

  testWidgets('la alerta de guardado no lleva animación de deslizamiento', (
    tester,
  ) async {
    await _montar(tester, const AgendaScreen());

    await tester.tap(find.byKey(const Key('actividad-favorito')).first);
    await tester.pump();

    // Con `SlideTransition` la alerta entraría desde abajo y su posición
    // cambiaría entre fotogramas; ahora aparece ya en su sitio.
    final alInstante = tester.getRect(find.byKey(const Key('alerta-guardado')));
    await tester.pump(const Duration(milliseconds: 400));
    final asentada = tester.getRect(find.byKey(const Key('alerta-guardado')));
    expect(alInstante.top, moreOrLessEquals(asentada.top, epsilon: 0.5));
  });

  testWidgets('«Agendar» de Post-Evento abre la ventana del formulario', (
    tester,
  ) async {
    await _montar(tester, PostEventoScreen(onBack: () {}));

    await tester.tap(find.text('Agendar con expertos'));
    await tester.pumpAndSettle();

    final boton = find.text('Agendar').first;
    await tester.ensureVisible(boton);
    await tester.pumpAndSettle();
    await tester.tap(boton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // La ventana se abre con la geometría de la de Registro. El WebView no
    // tiene implementación de plataforma en un test, así que su excepción se
    // descarta: lo que se comprueba aquí es el cableado del botón.
    tester.takeException();
    expect(find.byType(FormularioWebModal), findsOneWidget);
    expect(find.byKey(const Key('registro-panel')), findsOneWidget);
  });
}
