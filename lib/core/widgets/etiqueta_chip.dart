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
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        border: Border.all(color: AppColors.chipBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      // `Center(widthFactor: 1, ...)`, no `Container.alignment` - con
      // `alignment` el chip se estiraba a ocupar todo el ancho disponible
      // dentro de un `Wrap` (ahí las restricciones de ancho son acotadas,
      // a diferencia de un `Row`, donde no importaba) en vez de ceñirse al
      // texto. `widthFactor: 1` lo deja del ancho del texto sin importar
      // eso; el alto lo sigue centrando igual, ya fijo en 24 por el
      // `Container` de afuera.
      child: Center(
        widthFactor: 1,
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
      ),
    );
  }
}
