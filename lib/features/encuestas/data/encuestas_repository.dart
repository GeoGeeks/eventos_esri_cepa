import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'encuesta.dart';
import 'respuesta_encuesta.dart';

/// El backend rechazó `responder()` (ya había respondido, falta una
/// pregunta obligatoria, o el valor no calza con el tipo de la pregunta -
/// ver `RespuestasEncuestaService.responder` en `eventos_esri_cepa_api`).
/// [mensaje] es el texto real que mandó el backend, listo para mostrar tal
/// cual - mismo criterio que `RegistroLaboratorioRechazadoException`.
class ResponderEncuestaRechazadaException implements Exception {
  const ResponderEncuestaRechazadaException(this.mensaje);
  final String mensaje;
}

/// Comunicación con los endpoints de Encuestas (lado asistente) de
/// `eventos_esri_cepa_api` - mismo patrón que [AgendaRepository]/
/// [RegistroLaboratorioRepository]: envuelve [Dio] para poder mockearlo en
/// tests sin tocar la red real.
class EncuestasRepository {
  EncuestasRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<Options> _conToken() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    return Options(headers: {'Authorization': 'Bearer $accessToken'});
  }

  /// `GET /eventos/:idEvento/encuestas` - solo las `tipo: 'modulo'`, cada
  /// una con `yaRespondida` (ver `Encuesta.yaRespondida`).
  Future<List<Encuesta>> listar(String idEvento) async {
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/encuestas',
      options: await _conToken(),
    );
    return (respuesta.data ?? [])
        .map((json) => Encuesta.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// `GET /eventos/:idEvento/encuestas/post-evento` - `null` si el evento
  /// no tiene una configurada (404, no es un error de red real).
  Future<Encuesta?> postEvento(String idEvento) async {
    try {
      final respuesta = await _dio.get<Map<String, dynamic>>(
        '/eventos/$idEvento/encuestas/post-evento',
        options: await _conToken(),
      );
      return Encuesta.fromJson(respuesta.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Encuesta> detalle(String id) async {
    final respuesta = await _dio.get<Map<String, dynamic>>(
      '/encuestas/$id',
      options: await _conToken(),
    );
    return Encuesta.fromJson(respuesta.data!);
  }

  /// `null` si este asistente todavía no respondió `id` (404).
  Future<RespuestaEncuesta?> miRespuesta(String id) async {
    try {
      final respuesta = await _dio.get<Map<String, dynamic>>(
        '/encuestas/$id/mi-respuesta',
        options: await _conToken(),
      );
      return RespuestaEncuesta.fromJson(respuesta.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  /// [respuestas] es un mapa `preguntaId -> valor`, donde `valor` es lo que
  /// construye [PreguntaAbierta]/[PreguntaCalificacion]/[PreguntaSeleccion]/
  /// [PreguntaSeleccionMultiple] al capturar la respuesta (ver
  /// `_RespuestaEncuestaScreenState._enviar`) - ya en la forma exacta que
  /// espera `ResponderEncuestaDto` en el backend (`valorTexto`/
  /// `valorCalificacion`/`opcionIds`), así que se manda tal cual.
  ///
  /// @throws [ResponderEncuestaRechazadaException] si el backend rechaza la
  ///          respuesta (409 ya respondida, o 400 de validación).
  Future<RespuestaEncuesta> responder(
    String id,
    List<Map<String, dynamic>> respuestas,
  ) async {
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/encuestas/$id/respuestas',
        data: {'respuestas': respuestas},
        options: await _conToken(),
      );
      return RespuestaEncuesta.fromJson(respuesta.data!);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 409 || status == 400) {
        throw ResponderEncuestaRechazadaException(_mensajeDelBackend(e));
      }
      rethrow;
    }
  }

  String _mensajeDelBackend(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'No se pudo enviar la respuesta. Intenta de nuevo.';
  }
}
