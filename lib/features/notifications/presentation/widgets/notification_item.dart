import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  // Colores exactos del CSS de Figma
  static const _azul = Color(0xFF007AC2);
  static const _azulOscuro = Color(0xFF00619B);
  static const _circleBg = Color(0xFFD6EFFF);
  static const _textDark = Color(0xFF141414);
  static const _textGray = Color(0xFF4A4A4A);
  static const _textLightGray = Color(0xFF6B6B6B);
  static const _newBg = Color(0xFFEBEBEB);

  static const _fontFamily = 'Avenir Next LT Pro';
  static const _dateTimeIcon = 'assets/icons/date-time.svg';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(minHeight: 88),
      padding: isNew
          ? const EdgeInsets.all(16)
          : const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
      decoration: BoxDecoration(
        color: isNew ? _newBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon (Group 3 / Ellipse 7 + date-time.svg)
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: _circleBg,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              _dateTimeIcon,
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                _azulOscuro,
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
                // Frame 1447 -> título + (dot nuevo | fecha)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 20 / 16,
                          color: _textDark,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          color: _azul,
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: _textLightGray,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 2),

                // message -> descripción + (fecha si es nuevo)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontFamily: _fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 16 / 14,
                          color: _textGray,
                        ),
                      ),
                    ),
                    if (isNew)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 16 / 12,
                            color: _textLightGray,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                // Link "Revise los detalles" + indicator (línea azul opacity 0.4)
                Text(
                  'Revise los detalles',
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 16 / 14,
                    color: _azul,
                    decoration: TextDecoration.underline,
                    decorationColor: _azul.withOpacity(0.4),
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
