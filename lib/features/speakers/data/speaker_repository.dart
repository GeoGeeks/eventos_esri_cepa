import 'package:dio/dio.dart';

import '../../../core/network/renovacion_sesion.dart';
import '../../login/data/token_storage.dart';
import 'speaker.dart';

/// Comunicación con `GET /eventos/:idEvento/speakers` de
/// `eventos_esri_cepa_api` - mismo patrón que [AgendaRepository]: envuelve
/// [Dio] para poder mockearlo en tests sin tocar la red real.
class SpeakerRepository {
  SpeakerRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? crearDioApi(),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// El endpoint no tiene guard todavía (TEMPORAL, ver CLAUDE.md de la
  /// API) - se manda el token igual si existe, mismo criterio que
  /// `AgendaRepository.listarCatalogos`.
  Future<List<Speaker>> listar(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/speakers',
      options: accessToken == null
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map((json) => Speaker.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
