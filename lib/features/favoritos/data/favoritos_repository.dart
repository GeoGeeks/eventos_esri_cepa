import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'favorito_enriquecido.dart';

/// Comunicación con `/favoritos` de `eventos_esri_cepa_api` - mismo patrón
/// que el resto de repositorios de este repo.
class FavoritosRepository {
  FavoritosRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<List<FavoritoEnriquecido>> listar() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/favoritos',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map(
          (json) =>
              FavoritoEnriquecido.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> marcar({required String itemId, required String tipo}) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    await _dio.post<void>(
      '/favoritos',
      data: {'itemId': itemId, 'tipo': tipo},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// Puede fallar con 409 si `itemId` es una charla privada (el backend no
  /// deja quitarla, ver `FavoritosService.quitar`) - se deja propagar el
  /// error, el llamador decide cómo avisarlo.
  Future<void> quitar({required String itemId, required String tipo}) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    await _dio.delete<void>(
      '/favoritos/$itemId',
      queryParameters: {'tipo': tipo},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }
}
