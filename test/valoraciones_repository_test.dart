import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/login/data/token_storage.dart';
import 'package:esri_eventos/features/valoraciones/data/valoraciones_repository.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late ValoracionesRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = ValoracionesRepository(dio: dio, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('misValoraciones', () {
    test('hace GET y parsea la lista', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/valoraciones/mis-valoraciones',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/valoraciones/mis-valoraciones'),
          statusCode: 200,
          data: [
            {
              'id': 'val-1',
              'charlaId': 'charla-1',
              'estrellas': 5,
              'comentario': 'Excelente',
              'createdAt': '2026-09-01T00:00:00.000Z',
            },
          ],
        ),
      );

      final valoraciones = await repositorio.misValoraciones();

      expect(valoraciones, hasLength(1));
      expect(valoraciones.first.charlaId, 'charla-1');
      expect(valoraciones.first.estrellas, 5);
    });
  });

  group('crear', () {
    test('hace POST con charlaId/estrellas/comentario', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/valoraciones'),
          statusCode: 201,
          data: {
            'id': 'val-1',
            'charlaId': 'charla-1',
            'estrellas': 4,
            'comentario': 'Muy buena',
            'createdAt': '2026-09-01T00:00:00.000Z',
          },
        ),
      );

      final valoracion = await repositorio.crear(
        charlaId: 'charla-1',
        estrellas: 4,
        comentario: 'Muy buena',
      );

      expect(valoracion.id, 'val-1');
      final llamada = verify(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured.single, {
        'charlaId': 'charla-1',
        'estrellas': 4,
        'comentario': 'Muy buena',
      });
    });

    test('sin comentario, no manda esa clave', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/valoraciones'),
          statusCode: 201,
          data: {
            'id': 'val-1',
            'charlaId': 'charla-1',
            'estrellas': 3,
            'comentario': null,
            'createdAt': '2026-09-01T00:00:00.000Z',
          },
        ),
      );

      await repositorio.crear(charlaId: 'charla-1', estrellas: 3);

      final llamada = verify(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured.single, {
        'charlaId': 'charla-1',
        'estrellas': 3,
      });
    });

    test('403 (charla sin terminar) lanza ValoracionRechazadaException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/valoraciones'),
          response: Response(
            requestOptions: RequestOptions(path: '/valoraciones'),
            statusCode: 403,
            data: {'message': 'Todavia no se puede valorar esta charla.'},
          ),
        ),
      );

      await expectLater(
        repositorio.crear(charlaId: 'charla-1', estrellas: 5),
        throwsA(
          isA<ValoracionRechazadaException>().having(
            (e) => e.mensaje,
            'mensaje',
            'Todavia no se puede valorar esta charla.',
          ),
        ),
      );
    });

    test('409 (ya valorada) lanza ValoracionRechazadaException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/valoraciones'),
          response: Response(
            requestOptions: RequestOptions(path: '/valoraciones'),
            statusCode: 409,
            data: {'message': 'Ya valoro esta charla.'},
          ),
        ),
      );

      await expectLater(
        repositorio.crear(charlaId: 'charla-1', estrellas: 5),
        throwsA(isA<ValoracionRechazadaException>()),
      );
    });

    test('otros errores se propagan tal cual', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/valoraciones',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/valoraciones'),
          response: Response(
            requestOptions: RequestOptions(path: '/valoraciones'),
            statusCode: 500,
          ),
        ),
      );

      await expectLater(
        repositorio.crear(charlaId: 'charla-1', estrellas: 5),
        throwsA(isA<DioException>()),
      );
    });
  });
}
