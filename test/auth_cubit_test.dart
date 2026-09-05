import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/login/data/auth_repository.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_state.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

// Documento de prueba real usado consistentemente para probar login contra
// el backend (ver también los tests de widget) - no es un valor mágico
// arbitrario, es el número acordado para pruebas manuales/automáticas.
const _documentoDePrueba = '1007694735';

const _perfilJson = {
  'id': 'a1b2c3d4-0000-0000-0000-000000000000',
  'tipoDocumento': 'CC',
  'numeroDocumento': _documentoDePrueba,
  'nombres': 'Ana',
  'apellidos': 'Pérez',
  'email': 'ana.perez@example.com',
  'celular': '3001234567',
  'activo': true,
  'createdAt': '2026-01-01T00:00:00.000Z',
  'updatedAt': '2026-01-01T00:00:00.000Z',
};

Response<Map<String, dynamic>> _respuesta(
  String path, {
  required Map<String, dynamic> data,
  int statusCode = 200,
}) {
  return Response(
    requestOptions: RequestOptions(path: path),
    statusCode: statusCode,
    data: data,
  );
}

DioException _dioException(
  String path, {
  int? statusCode,
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  final requestOptions = RequestOptions(path: path);
  return DioException(
    requestOptions: requestOptions,
    type: type,
    response: statusCode == null
        ? null
        : Response(requestOptions: requestOptions, statusCode: statusCode),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late AuthCubit cubit;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    cubit = AuthCubit(
      repository: AuthRepository(dio: dio, tokenStorage: tokenStorage),
    );

    when(
      () => tokenStorage.guardarTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => tokenStorage.borrarTokens()).thenAnswer((_) async {});
  });

  tearDown(() => cubit.close());

  group('iniciarSesion', () {
    test('login exitoso emite Cargando y luego Autenticado', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => _respuesta(
          '/auth/login',
          data: {'accessToken': 'access-1', 'refreshToken': 'refresh-1'},
        ),
      );
      when(
        () => dio.get<Map<String, dynamic>>(
          '/usuarios/mi-perfil',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _respuesta('/usuarios/mi-perfil', data: _perfilJson),
      );

      // cubit.stream reparte los emit() como microtask - si se colecciona a
      // mano con listen()+cancel() se corre la carrera de cancelar antes de
      // que llegue el segundo estado. expectLater(...emitsInOrder...) queda
      // suscrito de una y espera cada emisión de verdad.
      final expectacion = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthCargando>(),
          isA<AuthAutenticado>().having(
            (s) => s.perfil.numeroDocumento,
            'perfil.numeroDocumento',
            _documentoDePrueba,
          ),
        ]),
      );

      await cubit.iniciarSesion(_documentoDePrueba);
      await expectacion;

      verify(
        () => tokenStorage.guardarTokens(
          accessToken: 'access-1',
          refreshToken: 'refresh-1',
        ),
      ).called(1);
    });

    test('documento no encontrado (401) emite AuthNoEncontrado', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
        ),
      ).thenThrow(_dioException('/auth/login', statusCode: 401));

      final expectacion = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthCargando>(), isA<AuthNoEncontrado>()]),
      );

      await cubit.iniciarSesion('0000000000');
      await expectacion;
    });

    test('error de red emite AuthError, no AuthNoEncontrado', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: any(named: 'data'),
        ),
      ).thenThrow(
        _dioException(
          '/auth/login',
          type: DioExceptionType.connectionError,
        ),
      );

      final expectacion = expectLater(
        cubit.stream,
        emitsInOrder([
          isA<AuthCargando>(),
          isA<AuthError>().having(
            (s) => s.mensaje,
            'mensaje',
            isNotEmpty,
          ),
        ]),
      );

      await cubit.iniciarSesion(_documentoDePrueba);
      await expectacion;
    });
  });

  group('verificarSesionExistente', () {
    test('con token guardado y válido, restaura la sesión', () async {
      when(
        () => tokenStorage.leerAccessToken(),
      ).thenAnswer((_) async => 'access-guardado');
      when(
        () => tokenStorage.leerRefreshToken(),
      ).thenAnswer((_) async => 'refresh-guardado');
      when(
        () => dio.get<Map<String, dynamic>>(
          '/usuarios/mi-perfil',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => _respuesta('/usuarios/mi-perfil', data: _perfilJson),
      );

      final expectacion = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthCargando>(), isA<AuthAutenticado>()]),
      );

      await cubit.verificarSesionExistente();
      await expectacion;
    });

    test('sin token guardado, se queda en AuthInicial (va a Login)', () async {
      when(() => tokenStorage.leerAccessToken()).thenAnswer((_) async => null);
      when(
        () => tokenStorage.leerRefreshToken(),
      ).thenAnswer((_) async => null);

      final expectacion = expectLater(
        cubit.stream,
        emitsInOrder([isA<AuthCargando>(), isA<AuthInicial>()]),
      );

      await cubit.verificarSesionExistente();
      await expectacion;

      verifyNever(
        () => dio.get<Map<String, dynamic>>(
          any(),
          options: any(named: 'options'),
        ),
      );
    });
  });
}
