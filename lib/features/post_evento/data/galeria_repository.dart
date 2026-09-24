import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';

/// Una foto de la galería del post-evento, ya en su orden.
class FotoGaleria {
  const FotoGaleria({required this.id, required this.url, required this.orden});

  final String id;
  final String url;
  final int orden;

  factory FotoGaleria.fromJson(Map<String, dynamic> json) => FotoGaleria(
    id: json['id'] as String,
    url: json['url'] as String,
    orden: json['orden'] as int,
  );
}

/// Galería del post-evento (`GET /eventos/:idEvento/galeria`): hasta 20
/// fotos administradas por Esri más los enlaces al álbum completo en Flickr
/// y al aftermovie (`null` si el evento no los tiene).
class GaleriaEvento {
  const GaleriaEvento({
    required this.fotos,
    this.flickrAlbumUrl,
    this.aftermovieUrl,
  });

  final List<FotoGaleria> fotos;
  final String? flickrAlbumUrl;
  final String? aftermovieUrl;

  factory GaleriaEvento.fromJson(Map<String, dynamic> json) {
    final fotos =
        (json['fotos'] as List<dynamic>? ?? [])
            .map((e) => FotoGaleria.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.orden.compareTo(b.orden));
    return GaleriaEvento(
      fotos: fotos,
      flickrAlbumUrl: json['flickrAlbumUrl'] as String?,
      aftermovieUrl: json['aftermovieUrl'] as String?,
    );
  }
}

/// El post-evento de ese evento todavía no está abierto (403 del backend,
/// `postEventoHabilitadoDesde` vacía o en el futuro) - la pantalla lo
/// muestra como un aviso, no como un error de conexión.
class GaleriaNoDisponibleException implements Exception {
  const GaleriaNoDisponibleException();
}

/// Envuelve [Dio] para poder mockearlo en tests sin red real - mismo patrón
/// que `EncuestasRepository`.
class GaleriaRepository {
  GaleriaRepository({Dio? dio, TokenStorage? tokenStorage})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
      _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// @throws [GaleriaNoDisponibleException] si el post-evento está cerrado.
  Future<GaleriaEvento> obtener(String idEvento) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    try {
      final respuesta = await _dio.get<Map<String, dynamic>>(
        '/eventos/$idEvento/galeria',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return GaleriaEvento.fromJson(respuesta.data!);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const GaleriaNoDisponibleException();
      }
      rethrow;
    }
  }
}
