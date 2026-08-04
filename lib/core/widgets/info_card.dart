import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';
import 'fila_meta.dart';

class InfoCard extends StatelessWidget {
  final String imagenAsset;
  final String titulo;
  final String subtitulo;
  final String? descripcion;
  final String? fecha;
  final String? lugar;
  final bool expandida;
  final VoidCallback? onExpandir;
  final VoidCallback? onAgendar;

  const InfoCard({
    super.key,
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    this.descripcion,
    this.fecha,
    this.lugar,
    this.expandida = false,
    this.onExpandir,
    this.onAgendar,
  });

  static const double anchoDetalle = 140;
  static const double altoDetalle = 36;
  static const double tamanoIconoDetalle = 15.975;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(minHeight: 128),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.surface3),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(46),
            child: Image.asset(
              imagenAsset,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  child: Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: Fonts.text1h,
                      fontWeight: Fonts.wMedium,
                      height: 24 / 18,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 16,
                  child: Text(
                    subtitulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.textSm,
                      fontWeight: Fonts.wRegular,
                      height: 16 / 14,
                      letterSpacing: 0,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                if (descripcion != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    descripcion!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.textSm,
                      fontWeight: Fonts.wRegular,
                      fontStyle: FontStyle.italic,
                      height: 16 / 14,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: onAgendar != null
                      ? _BotonAgendar(onTap: onAgendar!)
                      : Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onExpandir,
                            child: Transform.rotate(
                              angle: expandida ? math.pi : 0,
                              child: const AppIcon(
                                SvgIcon.arrow,
                                width: 14,
                                height: 8.4,
                                fit: BoxFit.fill,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                ),
                if (expandida && (fecha != null || lugar != null)) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    key: const Key('info-detalle'),
                    width: anchoDetalle,
                    height: altoDetalle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (fecha != null)
                          FilaMeta(
                            icono: SvgIcon.datetime,
                            texto: fecha!,
                            tamanoIcono: tamanoIconoDetalle,
                          ),
                        if (fecha != null && lugar != null)
                          const SizedBox(height: 4),
                        if (lugar != null)
                          FilaMeta(icono: SvgIcon.lugar, texto: lugar!),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonAgendar extends StatelessWidget {
  final VoidCallback onTap;

  const _BotonAgendar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 109,
        height: 32,
        color: AppColors.primary,
        alignment: Alignment.center,
        child: const Text(
          'Agendar',
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: Fonts.textSm,
            fontWeight: Fonts.wRegular,
            height: 20 / 14,
            letterSpacing: 0,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
