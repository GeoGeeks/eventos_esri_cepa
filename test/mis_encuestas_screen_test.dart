import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/encuestas/data/encuesta.dart';
import 'package:esri_eventos/features/encuestas/data/encuestas_repository.dart';
import 'package:esri_eventos/features/encuestas/data/encuestas_respondidas_de_evento.dart';
import 'package:esri_eventos/features/encuestas/data/respuesta_encuesta.dart';
import 'package:esri_eventos/features/encuestas/presentation/screens/encuesta_mi_respuesta_screen.dart';
import 'package:esri_eventos/features/encuestas/presentation/screens/mis_encuestas_screen.dart';

import 'fuentes_de_prueba.dart';

Encuesta _encuesta(String id, String idEvento, String titulo) => Encuesta(
  id: id,
  idEvento: idEvento,
  tipo: 'modulo',
  titulo: titulo,
  yaRespondida: true,
);

class _EncuestasFalsas extends EncuestasRepository {
  _EncuestasFalsas({this.grupos = const [], this.falla = false})
    : super(dio: Dio());

  final List<EncuestasRespondidasDeEvento> grupos;
  final bool falla;

  @override
  Future<List<EncuestasRespondidasDeEvento>> respondidas() async {
    if (falla) throw Exception('sin conexión');
    return grupos;
  }

  @override
  Future<RespuestaEncuesta?> miRespuesta(String id) async =>
      RespuestaEncuesta(id: 'r1', encuestaId: id, respuestasPorPregunta: {});
}

final _dosEventos = [
  EncuestasRespondidasDeEvento(
    idEvento: 'CUE',
    nombreEvento: 'CUE Colombia',
    encuestas: [
      _encuesta('ia', 'CUE', '¿Cómo aplicar IA a mis proyectos?'),
      _encuesta('post', 'CUE', 'Encuesta de satisfacción del evento'),
    ],
  ),
  EncuestasRespondidasDeEvento(
    idEvento: 'PE',
    nombreEvento: 'Planeta Esri Bogotá',
    encuestas: [_encuesta('lab', 'PE', 'Encuesta de laboratorios')],
  ),
];

Future<void> _montar(WidgetTester tester, EncuestasRepository repo) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MisEncuestasScreen(
          onBack: () {},
          onContactar: () {},
          repository: repo,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(cargarFuentesReales);

  testWidgets('un acordeón por evento, el primero abierto', (tester) async {
    await _montar(tester, _EncuestasFalsas(grupos: _dosEventos));

    expect(find.text('CUE Colombia'), findsOneWidget);
    expect(find.text('Planeta Esri Bogotá'), findsOneWidget);
    expect(find.byKey(const Key('mis-encuestas-ia')), findsOneWidget);
    expect(find.byKey(const Key('mis-encuestas-post')), findsOneWidget);
    expect(find.text('Ver respuestas'), findsNWidgets(2));
    // El segundo arranca cerrado.
    expect(find.byKey(const Key('mis-encuestas-lab')), findsNothing);
  });

  testWidgets('tocar otro evento lo abre y cierra el anterior', (tester) async {
    await _montar(tester, _EncuestasFalsas(grupos: _dosEventos));

    await tester.tap(find.text('Planeta Esri Bogotá'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mis-encuestas-lab')), findsOneWidget);
    expect(find.byKey(const Key('mis-encuestas-ia')), findsNothing);
  });

  testWidgets('Ver respuestas abre las respuestas', (tester) async {
    await _montar(tester, _EncuestasFalsas(grupos: _dosEventos));

    await tester.tap(find.byKey(const Key('mis-encuestas-ia')));
    await tester.pumpAndSettle();

    expect(find.byType(EncuestaMiRespuestaScreen), findsOneWidget);
  });

  testWidgets('sin encuestas respondidas lo dice', (tester) async {
    await _montar(tester, _EncuestasFalsas());

    expect(find.byKey(const Key('mis-encuestas-vacio')), findsOneWidget);
  });

  testWidgets('si falla la carga ofrece reintentar', (tester) async {
    await _montar(tester, _EncuestasFalsas(falla: true));

    expect(
      find.text('No se pudieron cargar las encuestas. Verifique su conexión.'),
      findsOneWidget,
    );
  });

  test('fromJson marca todas como respondidas', () {
    final grupo = EncuestasRespondidasDeEvento.fromJson({
      'idEvento': 'CUE',
      'nombreEvento': 'CUE Colombia',
      'encuestas': [
        {
          'id': 'e1',
          'idEvento': 'CUE',
          'tipo': 'post_evento',
          'titulo': 'Satisfacción',
          'preguntas': [],
          'respondidaEn': '2026-10-03T15:20:00.000Z',
        },
      ],
    });

    expect(grupo.encuestas.single.yaRespondida, isTrue);
  });
}
