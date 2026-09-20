import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';

/// El backend rechazó la solicitud por un dato inválido (correo mal
/// formado, algún campo vacío) - ver `CrearSolicitudSoporteDto` en
/// `eventos_esri_cepa_api`. [mensaje] es el texto real que mandó el backend.
class SolicitudSoporteInvalidaException implements Exception {
  const SolicitudSoporteInvalidaException(this.mensaje);
  final String mensaje;
}

/// Comunicación con `POST /soporte` de `eventos_esri_cepa_api`. A diferencia
/// del resto de repositorios de este feature, no manda token: la pantalla
/// "Contactar a Soporte" (`SoporteScreen`) es alcanzable desde
/// `VerificacionScreen` cuando el login falló, momento en el que todavía no
/// hay sesión que autenticar.
class SoporteRepository {
  SoporteRepository({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  final Dio _dio;

  /// @throws [SolicitudSoporteInvalidaException] si el backend rechaza el
  ///          body (400).
  Future<void> enviarSolicitud({
    required String correo,
    required String numeroDocumento,
    required String mensaje,
  }) async {
    try {
      await _dio.post<void>(
        '/soporte',
        data: {
          'correo': correo,
          'numeroDocumento': numeroDocumento,
          'mensaje': mensaje,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw SolicitudSoporteInvalidaException(_mensajeDelBackend(e));
      }
      rethrow;
    }
  }

  String _mensajeDelBackend(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] is List && data['message'].isNotEmpty) {
      return (data['message'] as List).first.toString();
    }
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return 'No pudimos enviar tu solicitud. Verifica los datos e intenta de nuevo.';
  }
}
