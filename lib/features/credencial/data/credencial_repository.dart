import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'credencial.dart';

/// Comunicación con `/eventos/:idEvento/credencial` de `eventos_esri_cepa_api`.
class CredencialRepository {
  CredencialRepository({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Find-or-create en el backend: la primera vez que se llama para un
  /// evento se crea la credencial, las veces siguientes devuelve la misma.
  Future<Credencial> obtener(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<Map<String, dynamic>>(
      '/eventos/$idEvento/credencial',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return Credencial.fromJson(respuesta.data!);
  }
}
