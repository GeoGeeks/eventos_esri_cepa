import 'package:flutter/widgets.dart';

import '../../../../core/widgets/formulario_web_modal.dart';

/// Ventana **Agendar con expertos** — `assets/views/agendar con expertos.svg`.
///
/// Misma geometría que la ventana de Registro (panel 358 × 673 en `top: 122`),
/// solo cambian el título y el formulario: aquí va el de reservas de Microsoft
/// Bookings. La abre el botón «Agendar» de la galería de Post-Evento.
class AgendarModal {
  AgendarModal._();

  static const String titulo = 'Agendar';

  /// Enlace de respaldo para el modo de prueba (sin evento real).
  static const String url =
      'https://bookings.cloud.microsoft/book/EsriColombiaEcuadorPanam@esri.co/'
      '?ismsaljsauthenabled=true';

  /// [enlace] es la agenda del experto que se tocó (cada uno tiene la
  /// suya, cargada desde el panel); sin él, el de respaldo.
  static Future<void> mostrar(BuildContext context, {String? enlace}) {
    return FormularioWebModal.mostrar(
      context,
      titulo: titulo,
      url: enlace ?? url,
    );
  }
}
