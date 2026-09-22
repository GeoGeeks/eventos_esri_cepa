import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../data/encuesta.dart';

/// Tarjeta de una encuesta `modulo` en la pestaña "Encuestas" de
/// `InvitadosScreen` - Figma nodo `56792:7883`/`56792:8218`
/// ("Encuestas", `Property 1=default|complete`). El único estado que
/// cambia es [Encuesta.yaRespondida]: "Responder encuesta" (azul enlace,
/// tappable) si todavía no, "Ver respuestas" (gris, tappable a la vista de
/// solo lectura) si ya.
class TarjetaEncuesta extends StatelessWidget {
  const TarjetaEncuesta({super.key, required this.encuesta, this.onTap});

  final Encuesta encuesta;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = encuesta.yaRespondida
        ? AppColors.textMuted
        : AppColors.textLink;
    final etiqueta = encuesta.yaRespondida
        ? 'Ver respuestas'
        : 'Responder encuesta';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          border: Border.all(color: AppColors.surface3, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              encuesta.titulo,
              style: const TextStyle(
                fontFamily: Fonts.medium,
                fontWeight: Fonts.wMedium,
                fontSize: Fonts.text0h,
                height: 20 / 16,
                color: AppColors.textTitle,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: color.withOpacity(0.4), width: 1),
                    ),
                  ),
                  child: Text(
                    etiqueta,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontWeight: Fonts.wRegular,
                      fontSize: 14,
                      height: 22 / 14,
                      color: color,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: math.pi,
                  child: AppIcon(
                    SvgIcon.back,
                    width: 8.414,
                    height: 14,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
