import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 362, // Ancho exacto de Figma
      height: 44, // Altura exacta de Figma
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: AppColors.requiredField.withOpacity(0.12),
          highlightColor: AppColors.requiredField.withOpacity(0.06),
          borderRadius: BorderRadius.circular(0.001),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.requiredField,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(0.001),
            ),
            child: const Center(
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.requiredField,
                  height: 1.25, // line-height 20px (125%)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
