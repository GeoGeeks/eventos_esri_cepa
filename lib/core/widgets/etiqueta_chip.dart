import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class EtiquetaChip extends StatelessWidget {
  final String texto;

  const EtiquetaChip({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        border: Border.all(color: AppColors.chipBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: Fonts.medium,
          fontSize: Fonts.textXs,
          fontWeight: Fonts.wMedium,
          height: 16 / 12,
          letterSpacing: 0,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
