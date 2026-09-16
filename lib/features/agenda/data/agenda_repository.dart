import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'catalogo_item.dart';
import 'charla.dart';
import 'laboratorio.dart';

/// Comunicación con los endpoints de Agenda de `eventos_esri_cepa_api`
/// (módulo `agenda`) - listar charlas/laboratorios de un evento y los
/// catálogos que alimentan el filtro. Mismo patrón que
/// [EventosRepository]/[NotificacionesRepository]: envuelve [Dio] para
/// poder mockearlo en tests sin tocar la red real.
class AgendaRepository {
  AgendaRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// `GET /eventos/:idEvento/charlas` - el backend ya filtra a solo
  /// `visibilidad: 'publica'` para este endpoint (JWT propio, no admin), y
  /// ya valida que el asistente esté inscrito al evento (o sea colaborador,
  /// ver `AsistenteInscritoEnEventoGuard`) - acá no hay nada más que
  /// replicar de esa lógica.
  Future<List<Charla>> listarCharlas(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/charlas',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map((json) => Charla.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// `GET /eventos/:idEvento/laboratorios`.
  Future<List<Laboratorio>> listarLaboratorios(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/laboratorios',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map((json) => Laboratorio.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// `GET /catalogos-agenda` - sin auth en el backend (ver ese repo,
  /// `CatalogosAgendaController`), pero se manda el token igual si existe
  /// por si algún día se protege sin tener que tocar este repositorio.
  Future<CatalogosAgenda> listarCatalogos() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<Map<String, dynamic>>(
      '/catalogos-agenda',
      options: accessToken == null
          ? null
          : Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return CatalogosAgenda.fromJson(respuesta.data ?? const {});
  }
}
