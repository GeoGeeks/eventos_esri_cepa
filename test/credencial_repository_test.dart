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
    test('hace GET a /eventos/:idEvento/credencial y parsea la respuesta', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/CUE2026/credencial',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/eventos/CUE2026/credencial'),
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
    });

    test('manda el Bearer token en la cabecera', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/eventos/CUE2026/credencial',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/eventos/CUE2026/credencial'),
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
