import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/widgets/app_icons.dart';
import '../data/agenda_mock_data.dart';

class ActividadCard extends StatelessWidget {
  final Actividad actividad;
  final bool expandida;
  final VoidCallback onExpandir;
  final VoidCallback? onFavorito;
  final VoidCallback onValorar;

  const ActividadCard({
    super.key,
    required this.actividad,
    required this.expandida,
    required this.onExpandir,
    this.onFavorito,
    required this.onValorar,
  });

  static const _metaStyle = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textSubtle,
  );

  static const _detalleStyle = TextStyle(
    fontFamily: Fonts.light,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wLight,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.modalSubtitle,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(12, 17, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  actividad.titulo,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: Fonts.text0h,
                    fontWeight: Fonts.wMedium,
                    height: 16 / 16,
                    letterSpacing: 0,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 14,
                    child: Text(
                      actividad.horario,
                      style: const TextStyle(
                        fontFamily: Fonts.light,
                        fontSize: Fonts.textXs,
                        fontWeight: Fonts.wLight,
                        height: 14 / 12,
                        letterSpacing: 0,
                        color: AppColors.textSubtle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onExpandir,
                    child: SizedBox(
                      width: 19,
                      height: 8.4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Transform.rotate(
                          angle: expandida ? math.pi : 0,
                          child: const AppIcon(
                            SvgIcon.arrow,
                            width: 14,
                            height: 8.4,
                            fit: BoxFit.fill,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          SizedBox(
            height: 16,
            child: Row(
              children: [
                const AppIcon(
                  SvgIcon.perfil,
                  width: 16,
                  height: 16,
                  color: AppColors.textSubtle,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    actividad.ponente,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _metaStyle,
                  ),
                ),
                GestureDetector(
                  onTap: onValorar,
                  child: Container(
                    height: 16,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0x66007AC2)),
                      ),
                    ),
                    child: const Text(
                      'Valorar',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: Fonts.textSm,
                        fontWeight: Fonts.wRegular,
                        height: 16 / 14,
                        letterSpacing: 0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),
          _FilaMeta(icono: SvgIcon.lugar, texto: actividad.lugar),
          const SizedBox(height: 2),
          _FilaMeta(icono: SvgIcon.aforo, texto: actividad.aforo),

          const SizedBox(height: 10),

          Row(
            children: [
              for (final etiqueta in actividad.etiquetas) ...[
                _Etiqueta(texto: etiqueta),
                const SizedBox(width: 8),
              ],
              const Spacer(),
              GestureDetector(
                key: const Key('actividad-favorito'),
                onTap: onFavorito,
                child: AppIcon(
                  actividad.favorita
                      ? SvgIcon.estrellaLlena
                      : SvgIcon.favoritos,
                  width: 24,
                  height: 24,
                  color: actividad.favorita
                      ? AppColors.primary
                      : AppColors.textSubtle,
                ),
              ),
            ],
          ),

          if (expandida) ...[
            const SizedBox(height: 10),
            Text(actividad.descripcion, style: _detalleStyle),
            const SizedBox(height: 10),
            SizedBox(
              height: 16,
              child: Text(
                actividad.tituloObjetivos,
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
                  for (var i = 0; i < actividad.objetivos.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    Text(
                      '${i + 1}. ${actividad.objetivos[i]}',
                      style: _detalleStyle,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilaMeta extends StatelessWidget {
  final String icono;
  final String texto;

  const _FilaMeta({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        children: [
          AppIcon(icono, width: 16, height: 16, color: AppColors.textSubtle),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ActividadCard._metaStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _Etiqueta extends StatelessWidget {
  final String texto;

  const _Etiqueta({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        border: Border.all(color: const Color(0x14000000)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontFamily: Fonts.medium,
          fontSize: Fonts.textXs,
          fontWeight: Fonts.wMedium,
          height: 16 / 12,
          letterSpacing: 0,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
