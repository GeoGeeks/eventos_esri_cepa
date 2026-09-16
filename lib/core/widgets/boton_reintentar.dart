import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

/// «Reintentar» de los estados de error — mismo estilo de texto-acción que
/// ya usa el resto de la app para este tipo de link (ver `_SeeAllChip` en
/// `inicio.dart`: Medium, color de marca, sin el azul/morado por defecto de
/// `TextButton`, que es lo que se veía antes de tener este widget).
class BotonReintentar extends StatelessWidget {
  final VoidCallback onPressed;

  const BotonReintentar({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text(
        'Reintentar',
        style: TextStyle(
          fontFamily: Fonts.medium,
          fontSize: Fonts.text0h,
          fontWeight: Fonts.wMedium,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
