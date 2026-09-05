import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import 'auth_exceptions.dart';
import 'perfil_usuario.dart';
import 'token_storage.dart';

/// Encapsula toda la comunicación con `POST /auth/login`,
/// `POST /auth/refresh`, `POST /auth/logout` y `GET /usuarios/mi-perfil` de
/// `eventos_esri_cepa_api` (ver ese repo, sección "Auth" de su CLAUDE.md).
///
/// Es el seam que [AuthCubit] usa en vez de hablarle a [Dio] directo, tanto
/// para mantener el Cubit simple como para poder mockear solo esta clase (o,
/// en los tests, el [Dio] que recibe) sin tocar `flutter_secure_storage`.
class AuthRepository {
  AuthRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Login sin contraseña: solo el número de documento. Si el backend lo
  /// encuentra en `eventosdb`, guarda los tokens y devuelve el perfil.
  Future<PerfilUsuario> iniciarSesion(String numeroDocumento) async {
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'numeroDocumento': numeroDocumento},
      );
      final datos = respuesta.data!;
      final accessToken = datos['accessToken'] as String;
      final refreshToken = datos['refreshToken'] as String;
      await _tokenStorage.guardarTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      return _obtenerPerfil(accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const DocumentoNoEncontradoException();
      }
      throw ErrorConexionException(_mensajeDeError(e));
    }
  }

  /// Para el arranque de la app: si hay tokens guardados y siguen (o se
  /// pueden refrescar) válidos, devuelve el perfil sin pedirle nada al
  /// usuario. Devuelve `null` si no hay sesión o no se pudo restaurar - en
  /// ese caso el llamador debe mostrar el login normal, nunca lanza.
  Future<PerfilUsuario?> restaurarSesion() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final refreshToken = await _tokenStorage.leerRefreshToken();
    if (accessToken == null || refreshToken == null) return null;

    try {
      return await _obtenerPerfil(accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) return null;
    }

    // El access token expiró - intenta refrescar una vez antes de rendirse.
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final datos = respuesta.data!;
      final nuevoAccessToken = datos['accessToken'] as String;
      final nuevoRefreshToken = datos['refreshToken'] as String;
      await _tokenStorage.guardarTokens(
        accessToken: nuevoAccessToken,
        refreshToken: nuevoRefreshToken,
      );
      return await _obtenerPerfil(nuevoAccessToken);
    } catch (_) {
      await _tokenStorage.borrarTokens();
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    if (accessToken != null) {
      try {
        await _dio.post<void>(
          '/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      } catch (_) {
        // Best-effort: si el logout remoto falla (sin red, token ya
        // vencido, etc.) igual se borra la sesión local.
      }
    }
    await _tokenStorage.borrarTokens();
  }

  Future<PerfilUsuario> _obtenerPerfil(String accessToken) async {
    final respuesta = await _dio.get<Map<String, dynamic>>(
      '/usuarios/mi-perfil',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return PerfilUsuario.fromJson(respuesta.data!);
  }

  String _mensajeDeError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'La conexión tardó demasiado. Intenta de nuevo.';
      case DioExceptionType.connectionError:
        return 'No hay conexión con el servidor. Revisa tu internet.';
      default:
        return 'Ocurrió un error de conexión. Intenta de nuevo.';
    }
  }
}
