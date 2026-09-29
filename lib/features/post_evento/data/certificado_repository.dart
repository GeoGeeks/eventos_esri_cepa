import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';

/// El backend no entregó el certificado por una regla de negocio - post-
/// evento cerrado o falta responder la encuesta (403), o el evento no tiene
/// certificado configurado (404). [mensaje] es el texto real del backend,
/// listo para mostrarle a la persona.
class CertificadoNoDisponibleException implements Exception {
  const CertificadoNoDisponibleException(this.mensaje);
  final String mensaje;
}

/// Descarga el certificado de asistencia (`GET /eventos/:idEvento/
/// certificado`, un PDF generado al vuelo) y lo deja en un archivo local
/// para abrirlo o compartirlo.
class CertificadoRepository {
  CertificadoRepository({
    Dio? dio,
    TokenStorage? tokenStorage,
    Future<Directory> Function()? carpetaDestino,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
       _tokenStorage = tokenStorage ?? TokenStorage(),
       _carpetaDestino = carpetaDestino ?? getTemporaryDirectory;

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// Seam para tests: `getTemporaryDirectory` necesita el canal de
  /// plataforma, que no existe en `flutter test`.
  final Future<Directory> Function() _carpetaDestino;

  /// Descarga el PDF y devuelve la ruta del archivo guardado.
  ///
  /// @throws [CertificadoNoDisponibleException] ante un 403/404 del backend.
  Future<File> descargar(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    final Response<List<int>> respuesta;
    try {
      respuesta = await _dio.get<List<int>>(
        '/eventos/$idEvento/certificado',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
          responseType: ResponseType.bytes,
        ),
      );
    } on DioException catch (e) {
      final estado = e.response?.statusCode;
      if (estado == 403 || estado == 404) {
        throw CertificadoNoDisponibleException(_mensaje(e.response?.data));
      }
      rethrow;
    }

    final carpeta = await _carpetaDestino();
    final archivo = File(
      '${carpeta.path}/${_nombreArchivo(respuesta.headers, idEvento)}',
    );
    await archivo.writeAsBytes(respuesta.data!, flush: true);
    return archivo;
  }

  /// Con `responseType: bytes` el cuerpo de un error también llega como
  /// bytes - se decodifica el `{ message }` de Nest a mano.
  static String _mensaje(Object? cuerpo) {
    const porDefecto = 'El certificado no está disponible todavía.';
    try {
      final texto = cuerpo is List<int>
          ? utf8.decode(cuerpo)
          : cuerpo?.toString() ?? '';
      final json = jsonDecode(texto);
      final mensaje = json is Map ? json['message'] : null;
      if (mensaje is String && mensaje.isNotEmpty) return mensaje;
      if (mensaje is List && mensaje.isNotEmpty) return '${mensaje.first}';
    } catch (_) {
      // Cuerpo que no es JSON: se usa el mensaje por defecto.
    }
    return porDefecto;
  }

  /// El nombre que sugiere el backend en `Content-Disposition`
  /// (`Certificado_<idEvento>_<Nombre>.pdf`), o uno genérico.
  static String _nombreArchivo(Headers headers, String idEvento) {
    final disposicion = headers.value('content-disposition') ?? '';
    final nombre = RegExp(r'filename="([^"]+)"').firstMatch(disposicion);
    return nombre?.group(1) ?? 'Certificado_$idEvento.pdf';
  }
}
