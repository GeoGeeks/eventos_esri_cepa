import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/core/network/renovacion_sesion.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockTokenStorage extends Mock implements TokenStorage {}

/// Adaptador HTTP de prueba: responde según la ruta y guarda cada petición.
class _AdaptadorFalso implements HttpClientAdapter {
  _AdaptadorFalso(this.responder);

  final ResponseBody Function(RequestOptions opciones) responder;
  final List<RequestOptions> peticiones = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    peticiones.add(options);
    return responder(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int estado, Object cuerpo) => ResponseBody.fromString(
  jsonEncode(cuerpo),
  estado,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

void main() {
  late _MockTokenStorage tokens;

  setUp(() {
    tokens = _MockTokenStorage();
    when(() => tokens.leerRefreshToken()).thenAnswer((_) async => 'refresh-1');
    when(
      () => tokens.guardarTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {});
    when(() => tokens.borrarTokens()).thenAnswer((_) async {});
  });

  /// API falsa: `/datos` responde 401 con el token viejo y 200 con el nuevo;
  /// `/auth/refresh` responde según [refreshValido].
  ({Dio dio, _AdaptadorFalso api, _AdaptadorFalso auth, RenovadorSesion sesion})
  montar({bool refreshValido = true}) {
    final auth = _AdaptadorFalso(
      (_) => refreshValido
          ? _json(200, {'accessToken': 'nuevo', 'refreshToken': 'refresh-2'})
          : _json(401, {'message': 'Refresh token invalido'}),
    );
    final dioAuth = Dio()..httpClientAdapter = auth;
    final sesion = RenovadorSesion(dio: dioAuth, tokenStorage: tokens);

    final api = _AdaptadorFalso(
      (opciones) => opciones.headers['Authorization'] == 'Bearer nuevo'
          ? _json(200, {'ok': true})
          : _json(401, {'message': 'Unauthorized'}),
    );
    final dio = crearDioApi(renovador: sesion)..httpClientAdapter = api;
    return (dio: dio, api: api, auth: auth, sesion: sesion);
  }

  Options conToken(String token) =>
      Options(headers: {'Authorization': 'Bearer $token'});

  test(
    'ante un 401 renueva el token y repite la llamada con el nuevo',
    () async {
      final m = montar();

      final respuesta = await m.dio.get<Map<String, dynamic>>(
        '/datos',
        options: conToken('viejo'),
      );

      expect(respuesta.data, {'ok': true});
      expect(m.api.peticiones, hasLength(2));
      expect(m.auth.peticiones.single.data, {'refreshToken': 'refresh-1'});
      verify(
        () => tokens.guardarTokens(
          accessToken: 'nuevo',
          refreshToken: 'refresh-2',
        ),
      ).called(1);
    },
  );

  test('si el refresh también da 401, borra la sesión y avisa', () async {
    final m = montar(refreshValido: false);
    var avisos = 0;
    m.sesion.alExpirarSesion = () => avisos++;

    await expectLater(
      m.dio.get<Map<String, dynamic>>('/datos', options: conToken('viejo')),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          401,
        ),
      ),
    );
    verify(() => tokens.borrarTokens()).called(1);
    expect(avisos, 1);
  });

  test('varias llamadas con 401 a la vez comparten un solo refresh', () async {
    final m = montar();

    await Future.wait([
      for (var i = 0; i < 3; i++)
        m.dio.get<Map<String, dynamic>>('/datos', options: conToken('viejo')),
    ]);

    expect(m.auth.peticiones, hasLength(1));
  });

  test('una llamada sin token no intenta renovar', () async {
    final m = montar();

    await expectLater(
      m.dio.get<Map<String, dynamic>>('/datos'),
      throwsA(isA<DioException>()),
    );
    expect(m.auth.peticiones, isEmpty);
  });

  test('sin conexión al renovar, no cierra la sesión', () async {
    final auth = _AdaptadorFalso(
      (opciones) => throw DioException.connectionError(
        requestOptions: opciones,
        reason: 'sin red',
      ),
    );
    final sesion = RenovadorSesion(
      dio: Dio()..httpClientAdapter = auth,
      tokenStorage: tokens,
    );
    var avisos = 0;
    sesion.alExpirarSesion = () => avisos++;

    expect(await sesion.renovar(), isNull);
    verifyNever(() => tokens.borrarTokens());
    expect(avisos, 0);
  });
}
