import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Línea de 1 px `#EBEBEB` que separa las opciones de una lista.
///
/// Es **la misma línea del filtro**: la que va bajo el título de cada grupo en
/// `FiltroPanel` y bajo «Modalidad» en los desplegables de Eventos, Reservados
/// e Historial, donde estaba escrita a mano como
/// `Container(height: 1, color: AppColors.lightGray)`.
///
/// Se extrajo aquí para que los desplegables Sí/No de la encuesta usen el
/// mismo widget en vez de una copia más.
class SeparadorOpciones extends StatelessWidget {
  const SeparadorOpciones({super.key, this.ancho});

  /// Ancho fijo. Por defecto ocupa todo el que le dé su caja.
  final double? ancho;

  static const double grosor = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho ?? double.infinity,
      height: grosor,
      color: AppColors.lightGray,
    );
  }
}
