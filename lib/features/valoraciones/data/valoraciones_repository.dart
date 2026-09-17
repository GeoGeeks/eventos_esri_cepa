import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'valoracion.dart';

/// La valoración fue rechazada por una regla de negocio del backend (la
/// charla todavía no termina, o el asistente ya la valoró antes) - ver
/// `ValoracionesService.crear` en `eventos_esri_cepa_api`. [mensaje] es el
/// texto real que mandó el backend, listo para mostrar tal cual.
class ValoracionRechazadaException implements Exception {
  const ValoracionRechazadaException(this.mensaje);
  final String mensaje;
}

/// Comunicación con `/valoraciones` de `eventos_esri_cepa_api`.
class ValoracionesRepository {
  ValoracionesRepository({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<List<Valoracion>> misValoraciones() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/valoraciones/mis-valoraciones',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map((json) => Valoracion.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// @throws [ValoracionRechazadaException] si el backend rechaza la
  ///          valoración (la charla no ha terminado, o ya estaba valorada
  ///          - ver el doc-comment de la clase).
  Future<Valoracion> crear({
    required String charlaId,
    required int estrellas,
    String? comentario,
  }) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/valoraciones',
        data: {
          'charlaId': charlaId,
          'estrellas': estrellas,
          if (comentario != null && comentario.isNotEmpty)
            'comentario': comentario,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return Valoracion.fromJson(respuesta.data!);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 403 || status == 409) {
        throw ValoracionRechazadaException(_mensajeDelBackend(e));
      }
      rethrow;
    }
  }

  String _mensajeDelBackend(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'No se pudo enviar la valoración. Intenta de nuevo.';
  }
}
