/// Configuración por entorno de la app.
///
/// [apiBaseUrl] apunta por defecto al backend de producción
/// (`eventos_esri_cepa_api`, ver `../../CLAUDE.md` de ese repo). Para
/// apuntar a otro entorno (por ejemplo el backend local en desarrollo) sin
/// tocar código, se pasa por `--dart-define` al compilar/correr:
///
/// ```
/// flutter run --dart-define=API_BASE_URL=http://localhost:3001/api
/// ```
class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://appmovilapi.esri.co/api',
  );
}
