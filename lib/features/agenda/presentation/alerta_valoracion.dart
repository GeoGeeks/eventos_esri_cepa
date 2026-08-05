import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/alerta_modal.dart';

/// Alerta **¡Gracias por su valoración!** — `assets/views/Valoración_gracias.svg`.
///
/// Panel de 360 × 121 en y=397,5 con barra verde arriba. Sale al enviar la
/// encuesta desde Agenda o desde Favoritos.
class AlertaValoracion {
  AlertaValoracion._();

  static Future<void> mostrar(BuildContext context, String espacio) {
    return AlertaModal.mostrar<void>(
      context,
      top: 397.5,
      constructor: (contexto) => AlertaModal(
        color: AppColors.success,
        titulo: '¡Gracias por su valoración!',
        descripcion: 'Hemos recibido sus comentarios sobre el espacio ',
        resaltado: '$espacio.',
        onCerrar: () => Navigator.of(contexto).pop(),
      ),
    );
  }
}
