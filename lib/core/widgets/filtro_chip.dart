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
        width: 78,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.chipBg : AppColors.white,
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: Fonts.light,
            fontSize: Fonts.textSm,
            fontWeight: Fonts.wLight,
            height: 20 / 14,
            letterSpacing: 0,
            color: AppColors.filterButtonText,
          ),
        ),
      ),
    );
  }
}
