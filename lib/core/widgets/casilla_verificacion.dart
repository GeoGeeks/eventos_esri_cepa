import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/icons.dart';
import 'app_icons.dart';

class CasillaVerificacion extends StatelessWidget {
  final bool marcada;
  final double lado;
  final double radio;

  const CasillaVerificacion({
    super.key,
    required this.marcada,
    this.lado = 16,
    this.radio = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lado,
      height: lado,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: marcada ? AppColors.primary : AppColors.white,
        border: Border.all(
          color: marcada ? AppColors.primary : AppColors.textSubtle,
        ),
        borderRadius: BorderRadius.circular(radio),
      ),
      child: marcada
          ? AppIcon(
              SvgIcon.check,
              width: lado * 0.625,
              height: lado * 0.625,
              color: AppColors.white,
            )
          : null,
    );
  }
}
