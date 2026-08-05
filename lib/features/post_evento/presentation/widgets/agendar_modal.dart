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

  static const String url =
      'https://bookings.cloud.microsoft/book/EsriColombiaEcuadorPanam@esri.co/'
      '?ismsaljsauthenabled=true';

  static Future<void> mostrar(BuildContext context) {
    return FormularioWebModal.mostrar(context, titulo: titulo, url: url);
  }
}
