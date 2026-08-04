import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_icons.dart';

class ECardActionButton extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onTap;

  const ECardActionButton({
    super.key,
    required this.iconAsset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 81,
        height: 59,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.lightGray, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icono 16x16px (icono real: compartir / guardar)
            AppIcon(
              iconAsset,
              width: 16,
              height: 16,
              color: AppColors.primary,
            ),

            /// Gap exacto de 4px (según Figma)
            const SizedBox(height: 4),

            /// Texto -> el spec usa font-family 'Inter' explícitamente
            /// para estos dos botones (no Avenir), así que se respeta.
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 15 / 12, // 125% line-height = 15px
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
