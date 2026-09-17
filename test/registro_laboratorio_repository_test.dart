import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/laboratorios/data/registro_laboratorio_repository.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late RegistroLaboratorioRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = RegistroLaboratorioRepository(
      dio: dio,
      tokenStorage: tokenStorage,
    );
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('misRegistros', () {
    test('parsea los registros con el laboratorio embebido', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/registros-laboratorio',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/registros-laboratorio'),
          statusCode: 200,
          data: [
            {
              'id': 'reg-1',
              'laboratorioId': 'lab-1',
              'fecha': '2026-10-02',
              'franjaHorariaId': 'franja-1',
              'laboratorio': {
                'id': 'lab-1',
                'idEvento': 'evt-1',
                'nombre': 'Taller de ArcGIS',
              },
              'asistencia': 'pendiente',
              'createdAt': '2026-09-01T00:00:00.000Z',
            },
          ],
        ),
      );

      final registros = await repositorio.misRegistros();

      expect(registros, hasLength(1));
      expect(registros.first.laboratorioId, 'lab-1');
      expect(registros.first.laboratorio?.nombre, 'Taller de ArcGIS');
    });
  });

  group('registrar', () {
    test('hace POST con el laboratorioId', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/registros-laboratorio',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/registros-laboratorio'),
          statusCode: 201,
          data: {
            'id': 'reg-1',
            'laboratorioId': 'lab-1',
            'fecha': '2026-10-01',
            'franjaHorariaId': 'franja-1',
            'asistencia': 'pendiente',
            'createdAt': '2026-09-01T00:00:00.000Z',
          },
        ),
      );

      final registro = await repositorio.registrar(
        'lab-1',
        '2026-10-01',
        'franja-1',
      );

      expect(registro.id, 'reg-1');
      final llamada = verify(
        () => dio.post<Map<String, dynamic>>(
          '/registros-laboratorio',
          data: captureAny(named: 'data'),
          options: any(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured.single, {
        'laboratorioId': 'lab-1',
        'fecha': '2026-10-01',
        'franjaHorariaId': 'franja-1',
      });
    });

    test('409 con mensaje del backend lanza RegistroLaboratorioRechazadoException', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/registros-laboratorio',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/registros-laboratorio'),
          response: Response(
            requestOptions: RequestOptions(path: '/registros-laboratorio'),
            statusCode: 409,
            data: {'message': 'Cupo de franja agotado'},
          ),
        ),
      );

      await expectLater(
        repositorio.registrar('lab-1', '2026-10-01', 'franja-1'),
        throwsA(
          isA<RegistroLaboratorioRechazadoException>().having(
            (e) => e.mensaje,
            'mensaje',
            'Cupo de franja agotado',
          ),
        ),
      );
    });

    test('otros errores se propagan tal cual', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/registros-laboratorio',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/registros-laboratorio'),
          response: Response(
            requestOptions: RequestOptions(path: '/registros-laboratorio'),
            statusCode: 500,
          ),
        ),
      );

      await expectLater(
        repositorio.registrar('lab-1', '2026-10-01', 'franja-1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('cancelar', () {
    test('hace DELETE al laboratorio', () async {
      when(
        () => dio.delete<void>(
          '/registros-laboratorio/lab-1',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/registros-laboratorio/lab-1'),
          statusCode: 200,
        ),
      );

      await repositorio.cancelar('lab-1');

      verify(
        () => dio.delete<void>(
          '/registros-laboratorio/lab-1',
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
