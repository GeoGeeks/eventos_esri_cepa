import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

/// Texto de una pregunta, con el asterisco rojo si es obligatoria - mismo
/// `RichText` que ya repetían `ValoracionPaso1Screen`/`ValoracionPaso2Screen`
/// para cada campo, factorizado aquí porque las 4 preguntas (abierta,
/// selección, selección múltiple, calificación) lo necesitan por igual.
class EtiquetaPregunta extends StatelessWidget {
  const EtiquetaPregunta({
    super.key,
    required this.texto,
    required this.obligatoria,
  });

  final String texto;
  final bool obligatoria;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: Fonts.regular,
          fontWeight: Fonts.wRegular,
          fontSize: Fonts.text0h,
          height: 20 / 16,
          color: AppColors.textTitle,
        ),
        children: [
          TextSpan(text: texto),
          if (obligatoria)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: AppColors.requiredField),
            ),
        ],
      ),
    );
  }
}
