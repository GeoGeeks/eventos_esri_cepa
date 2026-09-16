import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'evento.dart';

/// Encapsula `GET /eventos` y `GET /eventos/mis-inscripciones` de
/// `eventos_esri_cepa_api` - mismo criterio que `AuthRepository` (seam para
/// tests, sin hablarle a `Dio` directo desde `EventosStore`).
class EventosRepository {
  EventosRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<Options> _conToken() async {
    final token = await _tokenStorage.leerAccessToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  /// Todos los eventos activos - `EventoExterno` fusionado con su
  /// `EventoExtension` (portada, hora real) en el propio backend, ver
  /// `EventosDbController.listarActivos` en `eventos_esri_cepa_api`.
  Future<List<Evento>> listarActivos() async {
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos',
      options: await _conToken(),
    );
    return (respuesta.data ?? [])
        .map((json) => Evento.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Solo los `IDEvento` a los que la persona esta inscrita - la respuesta
  /// real trae filas de `eventosdb.RegistroEvento` (inscripcion), no el
  /// `Evento` completo (ver `EventosDbController.misInscripciones`, que a
  /// proposito NO se fusiona con la extension local) - por eso este metodo
  /// solo extrae el id, y `EventosStore` cruza contra `listarActivos()` para
  /// armar "Eventos reservados" con los datos completos.
  ///
  /// Un colaborador interno nunca tiene fila aca (no tiene
  /// `eventosdb.RegistroEvento`, ver CLAUDE.md de la API, "Colaboradores
  /// internos") - la lista viene vacia, no es un error.
  Future<Set<String>> listarIdsInscritos() async {
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/mis-inscripciones',
      options: await _conToken(),
    );
    return (respuesta.data ?? [])
        .map((json) => (json as Map<String, dynamic>)['IDEvento'] as String)
        .toSet();
  }
}
