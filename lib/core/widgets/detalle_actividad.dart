import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class DetalleActividad extends StatelessWidget {
  final String descripcion;
  final String tituloObjetivos;
  final List<String> objetivos;

  const DetalleActividad({
    super.key,
    required this.descripcion,
    required this.tituloObjetivos,
    required this.objetivos,
  });

  static const TextStyle estiloTexto = TextStyle(
    fontFamily: Fonts.light,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wLight,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.modalSubtitle,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(descripcion, style: estiloTexto),
        const SizedBox(height: 10),
        SizedBox(
          height: 16,
          child: Text(
            tituloObjetivos,
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.textSm,
              fontWeight: Fonts.wMedium,
              height: 16 / 14,
              letterSpacing: 0,
              color: AppColors.modalSubtitle,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < objetivos.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                Text('${i + 1}. ${objetivos[i]}', style: estiloTexto),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
