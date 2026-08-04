import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final bool showBorder;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0x1F000000),
        highlightColor: const Color(0x0A000000),
        child: Container(
          // List Item: 362px x 56px
          width: 362,
          height: 56,
          // Indentación de 16px hacia la derecha respecto al título de sección
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            // bordered-container: 346px x 56px (362 - 16 = 346)
            decoration: BoxDecoration(
              border: showBorder
                  ? const Border(
                      bottom: BorderSide(
                        color: AppColors.surface3,
                        width: 1,
                      ),
                    )
                  : null,
            ),
            padding: const EdgeInsets.only(top: 10, right: 16, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícono (24x24 px estricto)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSubtle,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12), // gap: 12px

                // Label (294x20 px)
                Expanded(
                  child: SizedBox(
                    height: 20,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTitle,
                        height: 1.25,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
