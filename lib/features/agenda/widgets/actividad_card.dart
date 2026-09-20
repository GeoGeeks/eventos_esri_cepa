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
                // Sin `maxLines`: un título largo baja de renglón y la tarjeta
                // crece con él. Nunca se recorta ni se encoge la fuente.
                child: Text(
                  actividad.titulo,
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
                  // Sin descripción ni objetivos no hay nada que ver al
                  // expandir - se oculta la flecha entera en vez de dejarla
                  // abrir una tarjeta vacía (ver Actividad.tieneDetalle).
                  if (actividad.tieneDetalle) ...[
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
                ],
              ),
            ],
          ),

          // Sin ponente NI «Valorar» (charla real que todavía no terminó,
          // o sin `horaFin` - ver `Actividad.mostrarValorar`) no queda
          // nada que pintar en esta fila: se oculta entera, igual que
          // lugar/aforo más abajo.
          if (actividad.ponente.isNotEmpty || actividad.mostrarValorar) ...[
            const SizedBox(height: 4),
            SizedBox(
              height: 16,
              child: Row(
                children: [
                  // Sin ponente (la Charla real no siempre lo trae, ver el
                  // doc-comment de esa clase) no se pinta ni el ícono ni el
                  // texto - «Valorar» se corre a la derecha igual.
                  if (actividad.ponente.isNotEmpty) ...[
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
                  ] else if (actividad.mostrarValorar)
                    const Spacer(),
                  // Una vez valorada, la palabra **sigue viéndose** y tanto
                  // ella como la línea de debajo pasan de azul a #949494.
                  if (actividad.mostrarValorar)
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
                            color: actividad.valorada
                                ? AppColors.textSubtle
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Sin día (la Charla real no siempre lo trae, y el mock nunca lo
          // define) no se pinta ni el ícono ni la fila - mismo criterio que
          // lugar/aforo. Pedido explícito de la PO: el día no aparecía en
          // ningún lado de la tarjeta.
          if (actividad.dia.isNotEmpty) ...[
            const SizedBox(height: 2),
            FilaMeta(icono: SvgIcon.date, texto: actividad.dia),
          ],

          // Sin lugar/aforo (la Charla real no siempre los trae) no se
          // pinta ni el ícono ni la fila entera - antes quedaba el ícono
          // solo, sin texto al lado.
          if (actividad.lugar.isNotEmpty) ...[
            const SizedBox(height: 2),
            FilaMeta(icono: SvgIcon.lugar, texto: actividad.lugar),
          ],
          if (actividad.aforo.isNotEmpty) ...[
            const SizedBox(height: 2),
            FilaMeta(icono: SvgIcon.aforo, texto: actividad.aforo),
          ],

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // `Wrap` dentro del `Expanded` (no un `Row` a secas) - con
              // varias etiquetas reales (temática + producto + nivel
              // juntos) desbordaba en vez de pasar a la siguiente línea.
              // La estrella se queda fija a la derecha igual que antes.
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final etiqueta in actividad.etiquetas)
                      EtiquetaChip(texto: etiqueta),
                  ],
                ),
              ),
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
