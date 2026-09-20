import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'expositor.dart';

/// Comunicación con `GET /eventos/:idEvento/expositores` de
/// `eventos_esri_cepa_api` - mismo patrón que [SpeakerRepository].
class ExpositorRepository {
  ExpositorRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// [tipo] filtra por 'stand' o 'experiencia' (`?tipo=`) - el backend ya
  /// lo soporta (`ExpositoresController.listar`), así que no hace falta
  /// traer todo y filtrar en Flutter. Sin guard todavía (TEMPORAL, ver
  /// CLAUDE.md de la API) - se manda el token igual si existe.
  Future<List<Expositor>> listar(String idEvento, {String? tipo}) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/expositores',
      queryParameters: tipo == null ? null : {'tipo': tipo},
      options: accessToken == null
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map((json) => Expositor.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
