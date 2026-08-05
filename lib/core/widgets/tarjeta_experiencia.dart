import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';
import 'fila_meta.dart';

/// Tarjeta de **Experiencias** y **Stands** — `assets/views/experiencias_card.svg`
/// y `assets/views/Stand.svg`.
///
/// Es un solo widget con dos estados. El encabezado (foto, título y, en Stands,
/// subtítulo) y las filas de fecha y lugar se ven siempre; al expandir se
/// **inserta** entre unos y otras la descripción y el enlace, que es como lo
/// dibujan los dos SVG.
///
/// Los textos no se recortan: crecen en líneas y la tarjeta crece con ellos.
class TarjetaExperiencia extends StatelessWidget {
  final String imagenAsset;

  /// Avenir Medium 18/24 `#141414`.
  final String titulo;

  /// Solo en Stands. Avenir Regular 14/16 `#6B6B6B`.
  final String? subtitulo;

  /// Avenir Regular 14/16 `#949494`, con ícono de 16.
  final String fecha;
  final String lugar;

  /// Solo al expandir. Avenir Regular **Italic subrayada** 12/16 `#141414`.
  final String? descripcion;

  /// Solo al expandir. Igual que [descripcion] pero en `#004874`.
  final String? enlace;

  final bool expandida;
  final VoidCallback? onExpandir;

  const TarjetaExperiencia({
    super.key,
    required this.imagenAsset,
    required this.titulo,
    required this.fecha,
    required this.lugar,
    this.subtitulo,
    this.descripcion,
    this.enlace,
    this.expandida = false,
    this.onExpandir,
  });

  // ── Medidas de los SVG ──

  /// Alto de la tarjeta plegada: 102 en Experiencias (sin subtítulo) y 120 en
  /// Stands (con subtítulo). Sale del contenido, no está fijado.
  static const double padding = 12;
  static const double padSuperior = 8;
  static const double tamanoFoto = 92;
  static const double separacionFoto = 12;

  /// Contenedor de la flecha, pegado al borde inferior.
  static const double altoFilaFlecha = 26;

  /// Título → subtítulo.
  static const double separacionSubtitulo = 2;

  /// Último texto del encabezado → primera fila de metadatos.
  static const double separacionMeta = 6;

  /// Entre la fila de fecha y la de lugar.
  static const double separacionDetalle = 4;

  /// Alrededor del bloque que aparece al expandir.
  static const double separacionDesplegado = 10;

  static const TextStyle estiloTitulo = TextStyle(
    fontFamily: Fonts.medium,
    fontSize: Fonts.text1h,
    fontWeight: Fonts.wMedium,
    height: 24 / 18,
    letterSpacing: 0,
    color: AppColors.textTitle,
  );

  static const TextStyle estiloSubtitulo = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );

  /// Itálica subrayada de 12/16. El diseño la usa tanto para la descripción
  /// como para el correo; solo cambia el color.
  static TextStyle estiloDesplegado(Color color) => TextStyle(
        fontFamily: Fonts.regular,
        fontSize: Fonts.textXs,
        fontWeight: Fonts.wRegular,
        fontStyle: FontStyle.italic,
        height: 16 / 12,
        letterSpacing: 0,
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: color,
      );

  @override
  Widget build(BuildContext context) {
    final bool hayDesplegable = descripcion != null || enlace != null;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.surface3),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(padding, padSuperior, padding, 0),
      child: Row(
        // La foto se centra respecto al contenido, así que baja al expandirse.
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(tamanoFoto),
            child: Image.asset(
              imagenAsset,
              width: tamanoFoto,
              height: tamanoFoto,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: separacionFoto),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(titulo, style: estiloTitulo),
                if (subtitulo != null) ...[
                  const SizedBox(height: separacionSubtitulo),
                  Text(subtitulo!, style: estiloSubtitulo),
                ],

                // Bloque que se inserta al expandir, entre el encabezado y los
                // metadatos, tal como lo dibujan los SVG.
                if (expandida && hayDesplegable) ...[
                  const SizedBox(height: separacionDesplegado),
                  if (descripcion != null)
                    Text(
                      descripcion!,
                      key: const Key('experiencia-descripcion'),
                      style: estiloDesplegado(AppColors.textTitle),
                    ),
                  if (descripcion != null && enlace != null)
                    const SizedBox(height: separacionDesplegado),
                  if (enlace != null)
                    Text(
                      enlace!,
                      key: const Key('experiencia-enlace'),
                      style: estiloDesplegado(AppColors.enlace),
                    ),
                ],

                const SizedBox(height: separacionMeta),
                FilaMeta(icono: SvgIcon.datetime, texto: fecha),
                const SizedBox(height: separacionDetalle),
                FilaMeta(icono: SvgIcon.lugar, texto: lugar),

                SizedBox(
                  height: altoFilaFlecha,
                  child: Align(
                    alignment: Alignment.centerRight,
                    // 12 de padding + 5 = los 17 que deja el SVG.
                    child: Padding(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
