import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistencia de "ya vio el onboarding" - a propósito INDEPENDIENTE de la
/// sesión (ver `TokenStorage`): debe sobrevivir un "Cerrar Sesión" +
/// volver a entrar, no solo un reinicio de la app con sesión activa. Sin
/// esto, `LoginScreen` mandaba a `OnboardingScreen` en cada login exitoso -
/// invisible mientras la sesión persistía (nunca se volvía a loguear a
/// mano), pero se repetía apenas alguien cerraba sesión y volvía a entrar.
///
/// Mismo patrón que `TokenStorage`: envuelto en una clase propia para poder
/// inyectar un doble en tests sin tocar el canal de plataforma real.
class OnboardingStorage {
  OnboardingStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _claveVisto = 'onboarding_visto';

  Future<bool> yaVisto() async {
    final valor = await _storage.read(key: _claveVisto);
    return valor == 'true';
  }

  Future<void> marcarVisto() async {
    await _storage.write(key: _claveVisto, value: 'true');
  }
}
