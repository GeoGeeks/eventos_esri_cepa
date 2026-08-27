import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

/// Mensaje de error que sale **debajo** de un campo obligatorio sin diligenciar.
///
/// Usa el mismo rojo que el asterisco de los campos obligatorios y que el
/// borde del campo con error de la pantalla de Verificación
/// (`AppColors.requiredField`, `#D83020`).
class MensajeErrorCampo extends StatelessWidget {
  const MensajeErrorCampo({super.key, this.texto = obligatorio});

  /// Texto por defecto: el de un campo obligatorio vacío.
  static const String obligatorio = 'Campo obligatorio';

  /// Separación entre el campo y el mensaje.
  static const double margenSuperior = 4;

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: margenSuperior),
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: Fonts.regular,
          fontWeight: Fonts.wRegular,
          fontSize: Fonts.textSm,
          height: 16 / 14,
          letterSpacing: 0,
          color: AppColors.requiredField,
        ),
      ),
    );
  }
}
