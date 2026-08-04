import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import 'app_icons.dart';

class FilaMeta extends StatelessWidget {
  final String icono;
  final String texto;
  final double tamanoIcono;

  const FilaMeta({
    super.key,
    required this.icono,
    required this.texto,
    this.tamanoIcono = 16,
  });

  static const TextStyle estiloTexto = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textSubtle,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        children: [
          AppIcon(
            icono,
            width: tamanoIcono,
            height: tamanoIcono,
            color: AppColors.textSubtle,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: estiloTexto,
            ),
          ),
        ],
      ),
    );
  }
}
