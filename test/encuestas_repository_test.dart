import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/encuestas/data/encuestas_repository.dart';
import 'package:esri_eventos/features/encuestas/data/pregunta.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late EncuestasRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = EncuestasRepository(dio: dio, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('listar', () {
    test('parsea las encuestas con sus preguntas ordenadas por orden', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/eventos/evt-1/encuestas',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/eventos/evt-1/encuestas'),
          statusCode: 200,
          data: [
            {
              'id': 'enc-1',
              'idEvento': 'evt-1',
              'tipo': 'modulo',
              'titulo': 'Encuesta A',
              'yaRespondida': true,
              'preguntas': [
                {
                  'id': 'p-2',
                  'orden': 1,
                  'texto': '¿Segunda?',
                  'tipo': 'calificacion',
                  'obligatoria': true,
                  'opciones': [],
                },
                {
                  'id': 'p-1',
                  'orden': 0,
                  'texto': '¿Primera?',
                  'tipo': 'abierta',
                  'obligatoria': false,
                  'opciones': [],
                },
              ],
            },
          ],
        ),
      );

      final encuestas = await repositorio.listar('evt-1');

      expect(encuestas, hasLength(1));
      final encuesta = encuestas.first;
      expect(encuesta.yaRespondida, isTrue);
      expect(encuesta.preguntas.map((p) => p.id), ['p-1', 'p-2']);
      expect(encuesta.preguntas[0].tipo, TipoPregunta.abierta);
      expect(encuesta.preguntas[1].tipo, TipoPregunta.calificacion);
    });
  });

  group('postEvento', () {
    test('null cuando el backend responde 404 (sin encuesta configurada)', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/evt-1/encuestas/post-evento',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/eventos/evt-1/encuestas/post-evento'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/eventos/evt-1/encuestas/post-evento'),
            statusCode: 404,
          ),
        ),
      );

      expect(await repositorio.postEvento('evt-1'), isNull);
    });

    test('otros errores se propagan tal cual', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/evt-1/encuestas/post-evento',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/eventos/evt-1/encuestas/post-evento'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/eventos/evt-1/encuestas/post-evento'),
            statusCode: 500,
          ),
        ),
      );

      await expectLater(
        repositorio.postEvento('evt-1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('miRespuesta', () {
    test('null cuando el asistente todavía no respondió (404)', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/encuestas/enc-1/mi-respuesta',
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/encuestas/enc-1/mi-respuesta'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/encuestas/enc-1/mi-respuesta'),
            statusCode: 404,
          ),
        ),
      );

      expect(await repositorio.miRespuesta('enc-1'), isNull);
    });

    test('indexa las respuestas por preguntaId', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/encuestas/enc-1/mi-respuesta',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/encuestas/enc-1/mi-respuesta'),
          statusCode: 200,
          data: {
            'id': 'resp-1',
            'encuestaId': 'enc-1',
            'respuestasPregunta': [
              {
                'preguntaId': 'p-1',
                'valorTexto': 'Muy buena',
                'valorCalificacion': null,
                'opciones': [],
              },
              {
                'preguntaId': 'p-2',
                'valorTexto': null,
                'valorCalificacion': null,
                'opciones': [
                  {'opcionId': 'o-1'},
                  {'opcionId': 'o-2'},
                ],
              },
            ],
          },
        ),
      );

      final respuesta = await repositorio.miRespuesta('enc-1');

      expect(respuesta, isNotNull);
      expect(respuesta!.respuestasPorPregunta['p-1']?.valorTexto, 'Muy buena');
      expect(respuesta.respuestasPorPregunta['p-2']?.opcionIds, ['o-1', 'o-2']);
    });
  });

  group('responder', () {
    test('hace POST con el arreglo de respuestas tal cual', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/encuestas/enc-1/respuestas',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/encuestas/enc-1/respuestas'),
          statusCode: 201,
          data: {
            'id': 'resp-1',
            'encuestaId': 'enc-1',
            'respuestasPregunta': [],
          },
        ),
      );

      final respuestas = [
        {'preguntaId': 'p-1', 'valorTexto': 'Muy buena'},
      ];
      await repositorio.responder('enc-1', respuestas);

      final llamada = verify(
        () => dio.post<Map<String, dynamic>>(
          '/encuestas/enc-1/respuestas',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured.single, {'respuestas': respuestas});
    });

    test('409 ya respondida lanza ResponderEncuestaRechazadaException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/encuestas/enc-1/respuestas',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions:
              RequestOptions(path: '/encuestas/enc-1/respuestas'),
          response: Response(
            requestOptions:
                RequestOptions(path: '/encuestas/enc-1/respuestas'),
            statusCode: 409,
            data: {'message': 'Ya respondio esta encuesta.'},
          ),
        ),
      );

      await expectLater(
        repositorio.responder('enc-1', const []),
        throwsA(
          isA<ResponderEncuestaRechazadaException>().having(
            (e) => e.mensaje,
            'mensaje',
            'Ya respondio esta encuesta.',
          ),
        ),
      );
    });
  });
}
