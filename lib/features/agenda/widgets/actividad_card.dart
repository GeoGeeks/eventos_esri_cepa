import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/detalle_actividad.dart';
import '../../../core/widgets/etiqueta_chip.dart';
import '../../../core/widgets/fila_meta.dart';
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
                    style: FilaMeta.estiloTexto,
                  ),
                ),
                // Una vez valorada, la palabra deja de verse y la línea que
                // había debajo pasa de azul a #949494.
                GestureDetector(
                  key: const Key('actividad-valorar'),
                  onTap: actividad.valorada ? null : onValorar,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: actividad.valorada
                              ? AppColors.textSubtle
                              : const Color(0x66007AC2),
                        ),
                      ),
                    ),
                    child: Text(
                      'Valorar',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: Fonts.textSm,
                        fontWeight: Fonts.wRegular,
                        height: 16 / 14,
                        letterSpacing: 0,
                        // Transparente en vez de quitar el texto: así la línea
                        // conserva el ancho que tenía la palabra.
                        color: actividad.valorada
                            ? Colors.transparent
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),
          FilaMeta(icono: SvgIcon.lugar, texto: actividad.lugar),
          const SizedBox(height: 2),
          FilaMeta(icono: SvgIcon.aforo, texto: actividad.aforo),

          const SizedBox(height: 10),

          Row(
            children: [
              for (final etiqueta in actividad.etiquetas) ...[
                EtiquetaChip(texto: etiqueta),
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
            DetalleActividad(
              descripcion: actividad.descripcion,
              tituloObjetivos: actividad.tituloObjetivos,
              objetivos: actividad.objetivos,
            ),
          ],
        ],
      ),
    );
  }
}
