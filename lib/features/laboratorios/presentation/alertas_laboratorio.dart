import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/alerta_modal.dart';

/// Qué hizo el usuario en la alerta de reserva confirmada.
enum ResultadoGracias {
  /// Pulsó «Cancelar reserva»: hay que abrir la alerta de cancelación.
  cancelar,

  /// Cerró con el aspa: vuelve a Laboratorios con la tarjeta desplegada.
  cerrar,
}

/// Qué hizo el usuario en la alerta de reserva cancelada.
enum ResultadoCancelada {
  /// «Reservar otro horario»: vuelve a Laboratorios con la tarjeta plegada.
  otroHorario,

  /// Aspa: vuelve a Laboratorios con la tarjeta desplegada.
  cerrar,
}

/// Alertas de Laboratorios — `Laboratorios_gracias.svg` y
/// `Laboratorios_delete.svg`. Las dos son [AlertaModal]; aquí van sus textos,
/// colores y la `y` a la que las coloca cada diseño.
class AlertasLaboratorio {
  AlertasLaboratorio._();

  /// «Gracias» — panel de 360 × 208 en y=354.
  static Future<ResultadoGracias?> gracias(BuildContext context) {
    return AlertaModal.mostrar<ResultadoGracias>(
      context,
      top: 354,
      constructor: (contexto) => AlertaModal(
        color: AppColors.success,
        titulo: 'Gracias',
        encabezado: '¡Su cupo a sido reservado con éxito!',
        descripcion:
            'Lo esperamos en nuestro laboratorio, debe presentarse 15 minutos '
            'antes al salón EFG y su cupo será reservado hasta pasados 5 '
            'minutos.',
        textoBoton: 'Cancelar reserva',
        botonRelleno: false,
        onBoton: () =>
            Navigator.of(contexto).pop(ResultadoGracias.cancelar),
        onCerrar: () => Navigator.of(contexto).pop(ResultadoGracias.cerrar),
      ),
    );
  }

  /// «Reserva cancelada» — panel de 360 × 192 en y=362.
  static Future<ResultadoCancelada?> cancelada(BuildContext context) {
    return AlertaModal.mostrar<ResultadoCancelada>(
      context,
      top: 362,
      constructor: (contexto) => AlertaModal(
        color: AppColors.requiredField,
        titulo: 'Reserva cancelada',
        encabezado: 'Su cupo fue liberado',
        descripcion:
            'Si cambia de idea puede volver a reservar mientras hayan cupos '
            'aun',
        textoBoton: 'Reservar otro horario',
        onBoton: () =>
            Navigator.of(contexto).pop(ResultadoCancelada.otroHorario),
        onCerrar: () => Navigator.of(contexto).pop(ResultadoCancelada.cerrar),
      ),
    );
  }
}
