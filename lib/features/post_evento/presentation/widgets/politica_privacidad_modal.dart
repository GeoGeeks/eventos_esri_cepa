import 'package:flutter/widgets.dart';

import '../../../../core/widgets/formulario_web_modal.dart';

/// Ventana **Política de privacidad** — la abre el enlace «Términos y
/// Condiciones» de la encuesta (Calificación evento, paso 2).
///
/// Usa el mismo mecanismo que Registro y Agendar con expertos: el contenido es
/// una página externa, así que se muestra dentro de la app en el WebView de
/// [FormularioWebModal] en vez de salir a un navegador.
class PoliticaPrivacidadModal {
  PoliticaPrivacidadModal._();

  static const String titulo = 'Política de privacidad';

  /// «Política de privacidad | Esri Colombia».
  static const String url = 'https://www.esri.co/es-co/privacidad';

  static Future<void> mostrar(BuildContext context) {
    return FormularioWebModal.mostrar(context, titulo: titulo, url: url);
  }
}
