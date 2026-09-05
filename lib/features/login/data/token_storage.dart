import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistencia de `accessToken`/`refreshToken` en almacenamiento seguro
/// (Keystore en Android, Keychain en iOS) - nunca en `SharedPreferences`.
///
/// Envuelto en una clase propia (en vez de usar `FlutterSecureStorage`
/// directo desde [AuthRepository]) para poder inyectar un doble de prueba en
/// los tests sin tocar canales de plataforma reales.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _claveAccessToken = 'access_token';
  static const _claveRefreshToken = 'refresh_token';

  Future<void> guardarTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _claveAccessToken, value: accessToken);
    await _storage.write(key: _claveRefreshToken, value: refreshToken);
  }

  Future<String?> leerAccessToken() => _storage.read(key: _claveAccessToken);

  Future<String?> leerRefreshToken() =>
      _storage.read(key: _claveRefreshToken);

  Future<void> borrarTokens() async {
    await _storage.delete(key: _claveAccessToken);
    await _storage.delete(key: _claveRefreshToken);
  }
}
