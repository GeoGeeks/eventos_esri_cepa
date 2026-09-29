import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/encuestas/data/encuesta.dart';
import 'package:esri_eventos/features/encuestas/data/encuestas_repository.dart';
import 'package:esri_eventos/features/encuestas/data/pregunta.dart';
import 'package:esri_eventos/features/encuestas/data/respuesta_encuesta.dart';
import 'package:esri_eventos/features/encuestas/presentation/screens/encuesta_responder_screen.dart';
import 'package:esri_eventos/features/encuestas/presentation/widgets/tarjeta_encuesta.dart';
import 'package:esri_eventos/core/widgets/mensaje_error_campo.dart';

import 'fuentes_de_prueba.dart';

class _MockEncuestasRepository extends Mock implements EncuestasRepository {}

class _RespuestaFalsa extends Fake implements RespuestaEncuesta {}

Future<void> _montar(WidgetTester tester, Widget pantalla) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pump();
}

Pregunta _abierta({required bool obligatoria}) => Pregunta(
      id: 'p-abierta',
      orden: 0,
      texto: '¿Comentario?',
      tipo: TipoPregunta.abierta,
      obligatoria: obligatoria,
    );

Pregunta _calificacion() => const Pregunta(
      id: 'p-calif',
      orden: 1,
      texto: '¿Qué tan útil fue?',
      tipo: TipoPregunta.calificacion,
      obligatoria: true,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
  });

  setUpAll(cargarFuentesReales);

  group('TarjetaEncuesta', () {
    testWidgets('sin responder muestra «Responder encuesta» y llama onTap', (
      tester,
    ) async {
      var tocada = false;
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'modulo',
        titulo: 'Encuesta de IA',
      );

      await _montar(
        tester,
        Scaffold(
          body: TarjetaEncuesta(
            encuesta: encuesta,
            onTap: () => tocada = true,
          ),
        ),
      );

      expect(find.text('Responder encuesta'), findsOneWidget);
      expect(find.text('Ver respuestas'), findsNothing);

      await tester.tap(find.byType(TarjetaEncuesta));
      expect(tocada, isTrue);
    });

    testWidgets('ya respondida muestra «Ver respuestas»', (tester) async {
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'modulo',
        titulo: 'Encuesta de IA',
        yaRespondida: true,
      );

      await _montar(
        tester,
        Scaffold(body: TarjetaEncuesta(encuesta: encuesta)),
      );

      expect(find.text('Ver respuestas'), findsOneWidget);
      expect(find.text('Responder encuesta'), findsNothing);
    });
  });

  group('EncuestaResponderScreen - una sola página', () {
    late _MockEncuestasRepository repositorio;

    setUp(() {
      repositorio = _MockEncuestasRepository();
    });

    testWidgets('no envía si falta la pregunta obligatoria', (tester) async {
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'modulo',
        titulo: 'Encuesta de IA',
        preguntas: [_abierta(obligatoria: true)],
      );

      await _montar(
        tester,
        EncuestaResponderScreen(encuesta: encuesta, repository: repositorio),
      );

      expect(find.text(MensajeErrorCampo.obligatorio), findsNothing);

      await tester.tap(find.text('Enviar'));
      await tester.pump();

      expect(find.text(MensajeErrorCampo.obligatorio), findsOneWidget);
      verifyNever(() => repositorio.responder(any(), any()));
    });

    testWidgets('con la respuesta diligenciada, envía y muestra éxito', (
      tester,
    ) async {
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'modulo',
        titulo: 'Encuesta de IA',
        preguntas: [_abierta(obligatoria: true)],
      );
      when(
        () => repositorio.responder(any(), any()),
      ).thenAnswer((_) async => _RespuestaFalsa());

      await _montar(
        tester,
        EncuestaResponderScreen(encuesta: encuesta, repository: repositorio),
      );

      await tester.enterText(find.byType(TextField), 'Muy buena experiencia');
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      final llamada = verify(
        () => repositorio.responder('enc-1', captureAny()),
      )..called(1);
      expect(llamada.captured.single, [
        {'preguntaId': 'p-abierta', 'valorTexto': 'Muy buena experiencia'},
      ]);
      expect(find.text('¡Gracias por su respuesta!'), findsOneWidget);
    });

    testWidgets('el backend rechazando la respuesta muestra el mensaje', (
      tester,
    ) async {
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'modulo',
        titulo: 'Encuesta de IA',
        preguntas: [_abierta(obligatoria: false)],
      );
      when(() => repositorio.responder(any(), any())).thenThrow(
        const ResponderEncuestaRechazadaException('Ya respondio esta encuesta.'),
      );

      await _montar(
        tester,
        EncuestaResponderScreen(encuesta: encuesta, repository: repositorio),
      );

      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      expect(find.text('Ya respondio esta encuesta.'), findsOneWidget);
    });
  });

  group('EncuestaResponderScreen - varias páginas', () {
    testWidgets(
      'preguntas que no caben en 536 se reparten en páginas con step-bars',
      (tester) async {
        // 4 preguntas abiertas (160 cada una + 12 de gap) exceden 536: la
        // tercera ya no cabe en la primera página (160*2+12=332,
        // 332+12+160=504 sí cabe la tercera... se agrega una cuarta para
        // forzar una segunda página con certeza).
        final preguntas = List.generate(
          4,
          (i) => Pregunta(
            id: 'p-$i',
            orden: i,
            texto: 'Pregunta $i',
            tipo: TipoPregunta.abierta,
            obligatoria: false,
          ),
        );
        final encuesta = Encuesta(
          id: 'enc-1',
          idEvento: 'evt-1',
          tipo: 'modulo',
          titulo: 'Encuesta larga',
          preguntas: preguntas,
        );
        final repositorio = _MockEncuestasRepository();

        await _montar(
          tester,
          EncuestaResponderScreen(encuesta: encuesta, repository: repositorio),
        );

        // Con step-bars visibles hay más de una página.
        expect(find.text('Continuar'), findsOneWidget);
        expect(find.text('Enviar'), findsNothing);

        // No todas las preguntas caben en la primera pantalla.
        expect(
          find.byType(TextField).evaluate().length,
          lessThan(preguntas.length),
        );
      },
    );

    testWidgets('una sola pregunta que cabe entera no muestra step-bars', (
      tester,
    ) async {
      final encuesta = Encuesta(
        id: 'enc-1',
        idEvento: 'evt-1',
        tipo: 'post_evento',
        titulo: 'Encuesta corta',
        preguntas: [_calificacion()],
      );
      final repositorio = _MockEncuestasRepository();

      await _montar(
        tester,
        EncuestaResponderScreen(encuesta: encuesta, repository: repositorio),
      );

      // Una sola página: el botón ya dice «Enviar» desde el arranque.
      expect(find.text('Enviar'), findsOneWidget);
    });
  });
}
