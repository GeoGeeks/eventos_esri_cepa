import 'dart:async';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../../features/login/data/token_storage.dart';

/// Renueva el access token con `POST /auth/refresh` cuando una llamada
/// responde 401, y deja la sesión cerrada si el refresh token tampoco sirve.
///
/// Antes cada repositorio mandaba el token guardado tal cual y nadie lo
/// renovaba con la app abierta: al vencer, todas las pantallas decían
/// «Verifique su conexión» (era un 401). Una sola instancia para toda la app
/// ([instancia]): si varias llamadas reciben 401 a la vez, comparten un único
/// refresh en vez de gastar el refresh token varias veces.
class RenovadorSesion {
  RenovadorSesion({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
      _tokenStorage = tokenStorage ?? TokenStorage();

  /// La que usan los repositorios a través de [crearDioApi].
  static RenovadorSesion instancia = RenovadorSesion();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Qué hacer cuando la sesión venció del todo (el refresh token también
  /// respondió 401): lo conecta `main.dart` para volver al inicio de sesión.
  void Function()? alExpirarSesion;

  Future<String?>? _enCurso;

  /// Pide un access token nuevo. Devuelve `null` si no se pudo: sin refresh
  /// token, refresh rechazado (sesión cerrada) o sin conexión (la sesión se
  /// conserva, la llamada original falla como siempre).
  Future<String?> renovar() => _enCurso ??= _renovar().whenComplete(() {
    _enCurso = null;
  });

  Future<String?> _renovar() async {
    final refreshToken = await _tokenStorage.leerRefreshToken();
    if (refreshToken == null) return null;
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final datos = respuesta.data!;
      final accessToken = datos['accessToken'] as String;
      await _tokenStorage.guardarTokens(
        accessToken: accessToken,
        refreshToken: datos['refreshToken'] as String,
      );
      return accessToken;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _tokenStorage.borrarTokens();
        alExpirarSesion?.call();
      }
      return null;
    }
  }
}

/// Marca en `RequestOptions.extra` de una llamada ya reintentada: si vuelve
/// a dar 401 no se renueva otra vez (evita un ciclo).
const _claveReintentada = 'sesionRenovada';

/// Ante un 401 de una llamada que llevaba `Authorization`, renueva el token
/// (ver [RenovadorSesion]) y la repite una vez con el nuevo. Las llamadas
/// sin token (login, soporte, endpoints públicos) no se tocan.
class InterceptorRenovacionSesion extends Interceptor {
  InterceptorRenovacionSesion(this._dio, {RenovadorSesion? renovador})
    : _renovador = renovador;

  final Dio _dio;
  final RenovadorSesion? _renovador;

  RenovadorSesion get _sesion => _renovador ?? RenovadorSesion.instancia;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final opciones = err.requestOptions;
    final llevabaToken = opciones.headers.containsKey('Authorization');
    if (err.response?.statusCode != 401 ||
        !llevabaToken ||
        opciones.extra[_claveReintentada] == true) {
      return handler.next(err);
    }

    final nuevoToken = await _sesion.renovar();
    if (nuevoToken == null) return handler.next(err);

    opciones.headers['Authorization'] = 'Bearer $nuevoToken';
    opciones.extra[_claveReintentada] = true;
    try {
      handler.resolve(await _dio.fetch<dynamic>(opciones));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}

/// Dio para los repositorios que llaman a la API con el token del
/// asistente: misma `baseUrl` de siempre más la renovación automática.
Dio crearDioApi({RenovadorSesion? renovador}) {
  final dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  dio.interceptors.add(InterceptorRenovacionSesion(dio, renovador: renovador));
  return dio;
}
