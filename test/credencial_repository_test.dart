import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/credencial/data/credencial_repository.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late CredencialRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = CredencialRepository(dio: dio, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('obtener', () {
    DioException errorDeLaApi(int status, Object? cuerpo) {
      final peticion = RequestOptions(path: '/eventos/CUE_26_CO/credencial');
      return DioException(
        requestOptions: peticion,
        response: Response(
          requestOptions: peticion,
          statusCode: status,
          data: cuerpo,
        ),
        type: DioExceptionType.badResponse,
      );
    }

    test(
      'un 404 con mensaje se convierte en CredencialNoDisponibleException con ese texto',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            '/eventos/CUE_26_CO/credencial',
            options: any(named: 'options'),
          ),
        ).thenThrow(
          errorDeLaApi(404, {
            'statusCode': 404,
            'message':
                'No encontramos su credencial. Acérquese al punto de registro con su documento.',
            'error': 'Not Found',
          }),
        );

        await expectLater(
          repositorio.obtener('CUE_26_CO'),
          throwsA(
            isA<CredencialNoDisponibleException>().having(
              (e) => e.mensaje,
              'mensaje',
              'No encontramos su credencial. Acérquese al punto de registro con su documento.',
            ),
          ),
        );
      },
    );

    test(
      'un error sin mensaje (p. ej. 500 o sin red) se propaga tal cual',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            '/eventos/CUE_26_CO/credencial',
            options: any(named: 'options'),
          ),
        ).thenThrow(errorDeLaApi(500, 'Internal Server Error'));

        await expectLater(
          repositorio.obtener('CUE_26_CO'),
          throwsA(isA<DioException>()),
        );
      },
    );

    test(
      'hace GET a /eventos/:idEvento/credencial y parsea la respuesta',
      () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            '/eventos/CUE2026/credencial',
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/eventos/CUE2026/credencial'),
            statusCode: 200,
            data: {
              'id': 'credencial-1',
              'idEvento': 'CUE2026',
              'estado': 'pendiente',
              'codigoQr':
                  '{"id":"credencial-1","nombre":"Ana","apellido":"Gomez","cedula":"111"}',
            },
          ),
        );

        final credencial = await repositorio.obtener('CUE2026');

        expect(credencial.id, 'credencial-1');
        expect(credencial.idEvento, 'CUE2026');
        expect(credencial.estado, 'pendiente');
        expect(
          credencial.codigoQr,
          '{"id":"credencial-1","nombre":"Ana","apellido":"Gomez","cedula":"111"}',
        );
      },
    );

    test('manda el Bearer token en la cabecera', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/CUE2026/credencial',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/eventos/CUE2026/credencial'),
          statusCode: 200,
          data: {
            'id': 'credencial-1',
            'idEvento': 'CUE2026',
            'estado': 'pendiente',
            'codigoQr':
                '{"id":"credencial-1","nombre":"Ana","apellido":"Gomez","cedula":"111"}',
          },
        ),
      );

      await repositorio.obtener('CUE2026');

      final llamada = verify(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/CUE2026/credencial',
          options: captureAny(named: 'options'),
        ),
      )..called(1);
      final opciones = llamada.captured.single as Options;
      expect(opciones.headers?['Authorization'], 'Bearer access-1');
    });
  });
}
