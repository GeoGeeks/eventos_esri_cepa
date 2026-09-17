import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';
import 'registro_laboratorio.dart';

/// El registro fue rechazado por una regla de negocio del backend (cupo de
/// franja agotado, cupo propio del laboratorio agotado, choque de horario
/// con otro registro, tope de laboratorios por asistente, o ya estaba
/// registrado) - ver `RegistrosLaboratorioService.registrar` en
/// `eventos_esri_cepa_api`. [mensaje] es el texto real que mandó el
/// backend, listo para mostrar tal cual.
class RegistroLaboratorioRechazadoException implements Exception {
  const RegistroLaboratorioRechazadoException(this.mensaje);
  final String mensaje;
}

/// Comunicación con `/registros-laboratorio` de `eventos_esri_cepa_api`.
///
/// ⚠️ El backend no expone "cuántos cupos quedan" para un laboratorio
/// puntual (solo valida al momento de registrar, ver
/// `RegistrosLaboratorioService` - el cupo de franja se comparte
/// dinámicamente entre todos los laboratorios de esa fecha+hora, no hay un
/// cálculo previo simple de exponer). Por eso esta app no puede mostrar
/// "agotado" de antemano en la lista - lo único real que se sabe sin
/// intentar registrar es si ESTE asistente ya tiene un registro para ese
/// laboratorio (`misRegistros()`); el estado "agotado" solo se descubre si
/// `registrar()` lo rechaza.
class RegistroLaboratorioRepository {
  RegistroLaboratorioRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<List<RegistroLaboratorio>> misRegistros() async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final respuesta = await _dio.get<List<dynamic>>(
      '/registros-laboratorio',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return (respuesta.data ?? [])
        .map(
          (json) =>
              RegistroLaboratorio.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// [franjaHorariaId] - cuál de las franjas que ofrece ese laboratorio
  /// (`Laboratorio.franjasHorarias`) elige el asistente.
  ///
  /// @throws [RegistroLaboratorioRechazadoException] si el backend rechaza
  ///          el registro por alguna regla de negocio (ver el doc-comment
  ///          de la clase), o si la franja no está habilitada para ese
  ///          laboratorio (`400`).
  Future<RegistroLaboratorio> registrar(
    String laboratorioId,
    String franjaHorariaId,
  ) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    try {
      final respuesta = await _dio.post<Map<String, dynamic>>(
        '/registros-laboratorio',
        data: {'laboratorioId': laboratorioId, 'franjaHorariaId': franjaHorariaId},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return RegistroLaboratorio.fromJson(respuesta.data!);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 409 || status == 400) {
        throw RegistroLaboratorioRechazadoException(_mensajeDelBackend(e));
      }
      rethrow;
    }
  }

  Future<void> cancelar(String laboratorioId) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    await _dio.delete<void>(
      '/registros-laboratorio/$laboratorioId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  String _mensajeDelBackend(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'No se pudo completar el registro. Intenta de nuevo.';
  }
}
