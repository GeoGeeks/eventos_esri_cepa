import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';

/// Alerta modal de confirmación — la comparten `Laboratorios_gracias.svg`,
/// `Laboratorios_delete.svg` y `Valoración_gracias.svg`.
///
/// Es un panel de 360 de ancho anclado a x=26, con una barra de color de 4 px
/// arriba, una cabecera de 53 con ícono, título y aspa, un cuerpo y —según el
/// caso— un pie con un solo botón alineado a la derecha.
///
/// La `y` viene por parámetro porque cada diseño la coloca a una altura
/// distinta: 354 la de reserva, 362 la de cancelación y 397,5 la de valoración.
class AlertaModal extends StatelessWidget {
  /// Color de la barra superior y del ícono.
  final Color color;

  /// Título de la cabecera. Avenir Medium 20/24.
  final String titulo;

  /// Primera línea del cuerpo, en Medium 16/20. Opcional: la alerta de
  /// valoración no la lleva.
  final String? encabezado;

  /// Cuerpo. Medium 16/20 cuando no hay [encabezado]; Regular 14/16 cuando sí.
  final String descripcion;

  /// Parte de [descripcion] que va resaltada al final, como el nombre del
  /// espacio valorado en `Valoración_gracias.svg`.
  final String? resaltado;

  /// Botón del pie. Sin él, la alerta no tiene pie.
  final String? textoBoton;
  final bool botonRelleno;
  final VoidCallback? onBoton;

  final VoidCallback onCerrar;

  const AlertaModal({
    super.key,
    required this.color,
    required this.titulo,
    required this.descripcion,
    required this.onCerrar,
    this.encabezado,
    this.resaltado,
    this.textoBoton,
    this.botonRelleno = true,
    this.onBoton,
  });

  // ── Medidas de los SVG ──
  static const double ancho = 360;
  static const double margenLateral = 26;
  static const double altoBarra = 4;
  static const double altoCabecera = 53;
  static const double altoPie = 57;
  static const double padding = 13;
  static const double tamanoIcono = 14.6;

  /// Muestra la alerta a la altura [top] del diseño, sin velo propio: el que
  /// hay detrás ya lo pone la pantalla.
  static Future<T?> mostrar<T>(
    BuildContext context, {
    required double top,
    required Widget Function(BuildContext) constructor,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: AppColors.modalOverlay,
      // Sin el SafeArea de showDialog: la `y` es absoluta, como en Figma.
      useSafeArea: false,
      builder: (contexto) => Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(
          top: top,
          left: margenLateral,
          right: margenLateral,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: constructor(contexto),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: altoBarra, width: ancho, color: color),
          _cabecera(),
          Container(height: 1, color: AppColors.surface3),
          _cuerpo(),
          if (textoBoton != null) ...[
            Container(height: 1, color: AppColors.surface3),
            _pie(),
          ],
        ],
      ),
    );
  }

  Widget _cabecera() {
    return SizedBox(
      height: altoCabecera,
      child: Row(
        children: [
          const SizedBox(width: padding),
          SvgPicture.asset(
            SvgIcon.checkCirculo,
            width: tamanoIcono,
            height: tamanoIcono,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 20,
                fontWeight: Fonts.wMedium,
                height: 24 / 20,
                letterSpacing: 0,
                color: AppColors.textTitle,
              ),
            ),
          ),
          GestureDetector(
            key: const Key('alerta-cerrar'),
            behavior: HitTestBehavior.opaque,
            onTap: onCerrar,
            // Caja de 32 con el aspa de 8: el vector queda a 20 del borde.
            child: SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: SvgPicture.asset(
                  SvgIcon.x,
                  width: 8.041,
                  height: 8.020,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textMuted,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _cuerpo() {
    const estiloFuerte = TextStyle(
      fontFamily: Fonts.medium,
      fontSize: Fonts.text0h,
      fontWeight: Fonts.wMedium,
      height: 20 / 16,
      letterSpacing: 0,
      color: AppColors.textTitle,
    );
    const estiloSuave = TextStyle(
      fontFamily: Fonts.regular,
      fontSize: Fonts.textSm,
      fontWeight: Fonts.wRegular,
      height: 16 / 14,
      letterSpacing: 0,
      color: AppColors.textTitle,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(padding, 15, padding, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (encabezado != null) ...[
            Text(encabezado!, style: estiloFuerte),
            const SizedBox(height: 5),
            Text(descripcion, style: estiloSuave),
          ] else
            // Sin encabezado el cuerpo va en Regular 16/20, y el trozo
            // resaltado —el nombre del espacio— en Medium.
            Text.rich(
              TextSpan(
                text: descripcion,
                style: estiloFuerte.copyWith(
                  fontFamily: Fonts.regular,
                  fontWeight: Fonts.wRegular,
                ),
                children: [
                  if (resaltado != null)
                    TextSpan(text: resaltado, style: estiloFuerte),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _pie() {
    return SizedBox(
      height: altoPie,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            key: const Key('alerta-boton'),
            onTap: onBoton,
            // Sin `alignment`: un Container que lo lleva se estira a todo el
            // ancho disponible, y el botón debe ceñirse a su texto.
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: botonRelleno ? AppColors.primary : AppColors.white,
                border: Border.all(color: AppColors.primary),
              ),
              child: Center(
                widthFactor: 1,
                child: Text(
                  textoBoton!,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.textSm,
                    fontWeight: Fonts.wRegular,
                    height: 16 / 14,
                    letterSpacing: 0,
                    color: botonRelleno ? AppColors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
