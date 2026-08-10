import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Ventana **Política de privacidad** — la abre el enlace «Términos y
/// Condiciones» de la encuesta (Calificación evento, paso 2).
///
/// El contenido es una página externa, así que se abre en el navegador
/// del dispositivo (no embebido dentro de la app).
class PoliticaPrivacidadModal {
  PoliticaPrivacidadModal._();

  static const String titulo = 'Política de privacidad';

  /// «Política de privacidad | Esri Colombia».
  static const String url = 'https://www.esri.co/es-co/privacidad';

  static Future<void> mostrar(BuildContext context) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
