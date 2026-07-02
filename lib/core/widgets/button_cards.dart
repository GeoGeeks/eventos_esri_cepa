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
    this.height = 36,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                ),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                  height: 20 / 16,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.cardBg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                side: const BorderSide(color: AppColors.primary, width: 1),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
                ),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  color: AppColors.primary,
                  fontSize: fontSize ?? 16,
                  fontWeight: FontWeight.w400,
                  height: 20 / 16,
                ),
              ),
            ),
    );
  }
}