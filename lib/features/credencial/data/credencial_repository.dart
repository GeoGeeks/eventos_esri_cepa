import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'credencial.dart';

/// La API no pudo entregar la credencial y explica por qué (`mensaje`, ya
/// redactado para el asistente).
class CredencialNoDisponibleException implements Exception {
  const CredencialNoDisponibleException(this.mensaje);

  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Comunicación con `/eventos/:idEvento/credencial` de `eventos_esri_cepa_api`.
class CredencialRepository {
  CredencialRepository({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Find-or-create en el backend: la primera vez que se llama para un
  /// evento se crea la credencial, las veces siguientes devuelve la misma.
  ///
  /// @throws [CredencialNoDisponibleException] cuando la API responde con un
  /// aviso para el asistente (p. ej. 404 en un evento cuya credencial emite
  /// logística y la persona no aparece): la app muestra ese texto tal cual,
  /// así el aviso se cambia desde la API sin publicar la app.
  Future<Credencial> obtener(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    try {
      final respuesta = await _dio.get<Map<String, dynamic>>(
        '/eventos/$idEvento/credencial',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return Credencial.fromJson(respuesta.data!);
    } on DioException catch (e) {
      final mensaje = _mensajeDeLaApi(e.response);
      if (mensaje != null) throw CredencialNoDisponibleException(mensaje);
      rethrow;
    }
  }

  /// El `message` de un 403/404/409 de la API, si es un texto para mostrar.
  static String? _mensajeDeLaApi(Response<dynamic>? respuesta) {
    const conAviso = {403, 404, 409};
    if (respuesta == null || !conAviso.contains(respuesta.statusCode)) {
      return null;
    }
    final datos = respuesta.data;
    final mensaje = datos is Map ? datos['message'] : null;
    return mensaje is String && mensaje.trim().isNotEmpty ? mensaje : null;
  }
}
