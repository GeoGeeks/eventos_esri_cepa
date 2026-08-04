import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final bool isNew;

  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.isNew = false,
  });

  static const String _dateTimeIcon = 'assets/icons/date-time.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(minHeight: 88),
      // isNew: padding 16px (todos los lados) -> notificación #EBEBEB
      // normal: padding 16px 12px -> notificación transparente
      padding: isNew
          ? const EdgeInsets.all(16)
          : const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
      decoration: BoxDecoration(
        color: isNew ? AppColors.lightGray : Colors.transparent, // #EBEBEB
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono Avatar (Group 3 / Ellipse 7 + date-time icon)
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.chipBg, // #D6EFFF
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              _dateTimeIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.filterButtonText, // #00619B
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // text-container
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === CSS: dos variantes distintas de layout ===
                //
                // Ítem NUEVO (Frame 1447, bg #EBEBEB):
                //   header -> título + Ellipse 8 (punto azul), SIN fecha
                //   message -> descripción + fecha (Frame 1448, justify:flex-end)
                //
                // Ítem NORMAL (Frame 1467):
                //   header -> título + fecha (Frame 1448)
                //   message -> solo descripción
                if (isNew) ...[
                  // Header: título + punto azul
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: Fonts.medium,
                            fontWeight: Fonts.wMedium,
                            fontSize: Fonts.text0h, // 16px
                            height: 20 / 16,
                            color: AppColors.textTitle, // #141414
                          ),
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary, // #007AC2
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  // Message: descripción + fecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          description,
                          style: const TextStyle(
                            fontFamily: Fonts.regular,
                            fontWeight: Fonts.wRegular,
                            fontSize: 14,
                            height: 16 / 14,
                            color: AppColors.modalSubtitle, // #4A4A4A
                          ),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        date,
                        style: const TextStyle(
                          fontFamily: Fonts.regular,
                          fontWeight: Fonts.wRegular,
                          fontSize: 12,
                          height: 16 / 12,
                          color: AppColors.textMuted, // #6B6B6B
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Header: título + fecha
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontFamily: Fonts.medium,
                            fontWeight: Fonts.wMedium,
                            fontSize: Fonts.text0h, // 16px
                            height: 20 / 16,
                            color: AppColors.textTitle, // #141414
                          ),
                        ),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          fontFamily: Fonts.regular,
                          fontWeight: Fonts.wRegular,
                          fontSize: 12,
                          height: 16 / 12,
                          color: AppColors.textMuted, // #6B6B6B
                        ),
                      ),
                    ],
                  ),
                  // Message: solo descripción
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontWeight: Fonts.wRegular,
                      fontSize: 14,
                      height: 16 / 14,
                      color: AppColors.modalSubtitle, // #4A4A4A
                    ),
                  ),
                ],

                // Enlace "Revise los detalles" (igual en ambas variantes)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Revise los detalles',
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontWeight: Fonts.wMedium,
                            fontSize: 14,
                            height: 16 / 14,
                            color: AppColors.primary, // #007AC2
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          height: 1,
                          // indicator: azul con opacity 0.4 (0.8 en variante "swipe abierto",
                          // que no aplica aquí porque ese estilo pertenece al Dismissible)
                          color: AppColors.primary.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
