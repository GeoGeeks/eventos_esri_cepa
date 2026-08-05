import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';
import 'fila_meta.dart';

/// Tarjeta de una persona del evento — Speakers e Invitados y Experiencias.
///
/// **Es un solo widget con dos estados**, no dos tarjetas: [expandida] decide
/// si debajo del encabezado aparecen la fecha y el lugar. El encabezado —foto,
/// nombre, cargo y título de la charla— es idéntico en los dos estados.
///
/// Los textos **no se recortan**: crecen a las líneas que hagan falta sin
/// cambiar el tamaño de la fuente ni poner puntos suspensivos, y la tarjeta
/// crece con ellos a partir de su alto mínimo de [altoMinimo].
///
/// Todos los datos entran por parámetro, así que el día que lleguen de un
/// backend basta con cambiar quién construye el widget.
class InfoCard extends StatelessWidget {
  final String imagenAsset;

  /// Nombre de la persona. Avenir Medium 18/24 `#141414`.
  final String titulo;

  /// Cargo. Avenir Regular 14/16 `#6B6B6B`.
  final String subtitulo;

  /// Título de la charla. Avenir Regular **Italic** 14/16 `#141414`.
  final String? descripcion;

  /// Solo visibles en el estado expandido. Avenir Regular 14/16 `#949494`.
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

  // ── Medidas de `assets/views/Invitados.svg` y del CSS de Figma ──

  /// Alto de la tarjeta plegada con la muestra del diseño. Es un **mínimo**:
  /// si el nombre o el título de la charla ocupan más líneas, la tarjeta crece.
  static const double altoMinimo = 128;

  /// Padding lateral: 12 a cada lado. La foto arranca en x=39 sobre un borde
  /// interior en 27.
  static const double padding = 12;

  /// Padding superior. Los 128 de la tarjeta salen de `8 + 92 + 26 + 2` de
  /// bordes: la fila de la flecha va **pegada al borde inferior**, sin margen.
  static const double padSuperior = 8;

  /// Foto: 92 × 92, circular, centrada verticalmente respecto al contenido.
  static const double tamanoFoto = 92;

  /// Separación entre la foto y el contenido.
  static const double separacionFoto = 12;

  /// Alto del contenedor que aloja la flecha, entre el título de la charla y
  /// la información desplegable.
  static const double altoFilaFlecha = 26;

  /// Separación entre nombre, cargo y título de la charla.
  static const double separacionTextos = 2;

  /// Separación entre la fecha y el lugar en el estado expandido.
  static const double separacionDetalle = 4;

  /// Padding derecho extra de la flecha, sobre los 12 de la tarjeta: en el SVG
  /// el chevron termina a 17 del borde.
  static const double padDerechoFlecha = 5;

  static const TextStyle estiloNombre = TextStyle(
    fontFamily: Fonts.medium,
    fontSize: Fonts.text1h,
    fontWeight: Fonts.wMedium,
    height: 24 / 18,
    letterSpacing: 0,
    color: AppColors.textTitle,
  );

  static const TextStyle estiloCargo = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );

  static const TextStyle estiloCharla = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    fontStyle: FontStyle.italic,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textTitle,
  );

  @override
  Widget build(BuildContext context) {
    final bool hayDetalle = fecha != null || lugar != null;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: altoMinimo),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.surface3),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(padding, padSuperior, padding, 0),
      child: Row(
        // La foto se centra respecto al contenido, así que baja un poco al
        // desplegarse la fecha y el lugar.
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
                Text(titulo, style: estiloNombre),
                const SizedBox(height: separacionTextos),
                Text(subtitulo, style: estiloCargo),
                if (descripcion != null) ...[
                  const SizedBox(height: separacionTextos),
                  Text(descripcion!, style: estiloCharla),
                ],

                // Contenedor de 26 con la flecha pegada a la derecha. En el
                // estado plegado es la última fila de la tarjeta; al expandirse
                // queda entre el encabezado y la información nueva.
                SizedBox(
                  // El botón «Agendar» mide 32, así que la fila se adapta a él
                  // cuando se usa esa variante en vez de la flecha.
                  height: onAgendar != null ? 32 : altoFilaFlecha,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: onAgendar != null
                        ? _BotonAgendar(onTap: onAgendar!)
                        : Padding(
                            padding: const EdgeInsets.only(
                              right: padDerechoFlecha,
                            ),
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

                if (expandida && hayDetalle)
                  Column(
                    key: const Key('info-detalle'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (fecha != null)
                        FilaMeta(icono: SvgIcon.datetime, texto: fecha!),
                      if (fecha != null && lugar != null)
                        const SizedBox(height: separacionDetalle),
                      if (lugar != null)
                        FilaMeta(icono: SvgIcon.lugar, texto: lugar!),
                    ],
                  ),
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
