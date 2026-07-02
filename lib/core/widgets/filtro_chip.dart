import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class FiltroChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FiltroChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.chipBg
              : AppColors.white,
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.filterButtonText,
            height: 1,
          ),
        ),
      ),
    );
  }
}