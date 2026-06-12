import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/fonts.dart';

enum ButtonCardsVariant { filled, outlined }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final ButtonCardsVariant variant;
  final double height;
  final double? fontSize;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonCardsVariant.filled,
    this.height = 44,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = variant == ButtonCardsVariant.filled;
    return SizedBox(
      height: height,
      child: isFilled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.avenir,
                  fontSize: fontSize ?? 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: Fonts.avenir,
                  color: AppColors.primary,
                  fontSize: fontSize ?? 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}
