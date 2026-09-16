import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/login/data/token_storage.dart';
import 'package:esri_eventos/features/notificaciones/data/notificaciones_repository.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late NotificacionesRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = NotificacionesRepository(dio: dio, tokenStorage: tokenStorage);
  });

  group('registrarDeviceToken', () {
    test('sin sesión guardada, no llama al backend', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => null);

      await repositorio.registrarDeviceToken(
        token: 'fcm-token-1',
        plataforma: 'ANDROID',
      );

      verifyNever(
        () => dio.post<void>(any(), data: any(named: 'data'), options: any(named: 'options')),
      );
    });

    test('con sesión, hace POST con el token y el header Authorization', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => 'access-1');
      when(
        () => dio.post<void>(
          '/notificaciones/device-token',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/notificaciones/device-token'),
          statusCode: 200,
        ),
      );

      await repositorio.registrarDeviceToken(
        token: 'fcm-token-1',
        plataforma: 'ANDROID',
      );

      final llamada = verify(
        () => dio.post<void>(
          '/notificaciones/device-token',
          data: captureAny(named: 'data'),
          options: captureAny(named: 'options'),
        ),
      )..called(1);
      expect(llamada.captured[0], {'token': 'fcm-token-1', 'plataforma': 'ANDROID'});
      final opciones = llamada.captured[1] as Options;
      expect(opciones.headers?['Authorization'], 'Bearer access-1');
    });
  });

  group('marcarLeido', () {
    test('sin sesión guardada, no llama al backend', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => null);

      await repositorio.marcarLeido('notificacion-1');

      verifyNever(
        () => dio.patch<void>(any(), options: any(named: 'options')),
      );
    });

    test('con sesión, hace PATCH al endpoint de esa notificación', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => 'access-1');
      when(
        () => dio.patch<void>(
          '/notificaciones/notificacion-1/leido',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions:
              RequestOptions(path: '/notificaciones/notificacion-1/leido'),
          statusCode: 200,
        ),
      );

      await repositorio.marcarLeido('notificacion-1');

      verify(
        () => dio.patch<void>(
          '/notificaciones/notificacion-1/leido',
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('es best-effort: si el backend falla, no relanza', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => 'access-1');
      when(
        () => dio.patch<void>(any(), options: any(named: 'options')),
      ).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/x')),
      );

      await expectLater(repositorio.marcarLeido('notificacion-1'), completes);
    });
  });
}
