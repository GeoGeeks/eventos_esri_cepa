import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../login/data/token_storage.dart';

/// Comunicación con los endpoints de `eventos_esri_cepa_api` que le tocan al
/// propio dispositivo del asistente (no a un admin): registrar el device
/// token FCM y confirmar que abrió una notificación. Ver ese repo, módulo
/// `notificaciones`.
///
/// Mismo patrón que [AuthRepository]: envuelve [Dio] para poder mockearlo en
/// tests sin tocar la red real.
class NotificacionesRepository {
  NotificacionesRepository({Dio? dio, TokenStorage? tokenStorage})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        _tokenStorage = tokenStorage ?? TokenStorage();

  final Dio _dio;
  final TokenStorage _tokenStorage;

  /// `plataforma` debe ser `'ANDROID'` o `'IOS'` (ver
  /// `PlataformaDispositivo` en el backend) - lo arma
  /// `PushNotificacionesService` según `Platform.isAndroid`/`isIOS`, no esta
  /// clase, para no depender de `dart:io` aquí.
  Future<void> registrarDeviceToken({
    required String token,
    required String plataforma,
  }) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    if (accessToken == null) return;

    await _dio.post<void>(
      '/notificaciones/device-token',
      data: {'token': token, 'plataforma': plataforma},
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
  }

  /// Best-effort: si falla (sin sesión, sin red, la notificación ya no
  /// existe), no debe romper el flujo de abrir la app - el usuario ya está
  /// viendo el contenido, confirmar la lectura es secundario.
  Future<void> marcarLeido(String idNotificacion) async {
    final accessToken = await _tokenStorage.leerAccessToken();
    if (accessToken == null) return;

    try {
      await _dio.patch<void>(
        '/notificaciones/$idNotificacion/leido',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } catch (_) {
      // Ver comentario del método.
    }
  }
}
