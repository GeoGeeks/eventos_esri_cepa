import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/favoritos/data/favoritos_repository.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late FavoritosRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = FavoritosRepository(dio: dio, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('listar', () {
    test('parsea charlas y laboratorios enriquecidos', () async {
      when(
        () => dio.get<List<dynamic>>('/favoritos', options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/favoritos'),
          statusCode: 200,
          data: [
            {
              'id': 'fav-1',
              'tipo': 'charla',
              'createdAt': '2026-09-01T00:00:00.000Z',
              'actividad': {
                'id': 'charla-1',
                'idEvento': 'evt-1',
                'nombre': 'Encuestas con IA',
                'fecha': '2026-10-01T00:00:00.000Z',
                'horaInicio': '2026-10-01T10:00:00.000Z',
                'horaFin': '2026-10-01T11:00:00.000Z',
                'visibilidad': 'publica',
              },
            },
          ],
        ),
      );

      final favoritos = await repositorio.listar();

      expect(favoritos, hasLength(1));
      expect(favoritos.first.tipo, 'charla');
      expect(favoritos.first.itemId, 'charla-1');
    });
  });

  group('marcar', () {
    test('hace POST con itemId y tipo', () async {
      when(
        () => dio.post<void>(
          '/favoritos',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/favoritos'),
          statusCode: 201,
        ),
      );

      await repositorio.marcar(itemId: 'charla-1', tipo: 'charla');

      final llamada = verify(
        () => dio.post<void>(
          '/favoritos',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured.single, {
        'itemId': 'charla-1',
        'tipo': 'charla',
      });
    });
  });

  group('quitar', () {
    test('hace DELETE con tipo como query param', () async {
      when(
        () => dio.delete<void>(
          '/favoritos/charla-1',
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/favoritos/charla-1'),
          statusCode: 200,
        ),
      );

      await repositorio.quitar(itemId: 'charla-1', tipo: 'charla');

      verify(
        () => dio.delete<void>(
          '/favoritos/charla-1',
          queryParameters: {'tipo': 'charla'},
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('propaga el error si el backend rechaza (charla privada)', () async {
      when(
        () => dio.delete<void>(
          any(),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/favoritos/charla-1'),
          response: Response(
            requestOptions: RequestOptions(path: '/favoritos/charla-1'),
            statusCode: 409,
          ),
        ),
      );

      expect(
        () => repositorio.quitar(itemId: 'charla-1', tipo: 'charla'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
