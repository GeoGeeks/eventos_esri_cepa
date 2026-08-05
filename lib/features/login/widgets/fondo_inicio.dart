import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';

class FondoInicio extends StatelessWidget {
  const FondoInicio({
    super.key,
    required this.child,
    this.aviso,
    this.espacioSuperior = 160,
  });

  final Widget child;
  final Widget? aviso;
  final double espacioSuperior;

  /// Alto al que se dibuja `esri_blanco.png`: 158 px de ancho sobre un
  /// original de 4096×674 dan 26, los mismos 26 que miden los SVG de vistas.
  static const double _altoPie = 158 * 674 / 4096;

  /// Separación entre el logo del pie y el borde inferior útil.
  static const double _margenPie = 24;

  /// El aviso de Verificación va a y=36 y mide 114 (`iniciarSesionVerificacion.svg`).
  /// 36 + 114 + 10 = 160 = `espacioSuperior` por defecto, así que el hueco que
  /// reserva la columna desplazable coincide con el sitio que ocupa el aviso.
  static const double _avisoTop = 36;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // Alto del teclado. Los tres Scaffold llevan resizeToAvoidBottomInset:false,
    // así que nadie encoge el cuerpo por nosotros: sólo recortamos el viewport
    // desplazable, y el fondo, el pie y el aviso se quedan donde están.
    final teclado = media.viewInsets.bottom;
    final barraEstado = media.padding.top;

    // viewPadding, no padding: al salir el teclado Android pone padding.bottom
    // en 0 —lo absorbe viewInsets— y el pie se iría 24 px hacia abajo.
    final barraNavegacion = media.viewPadding.bottom;

    // Sitio que ocupa el logo del pie más su margen.
    const reservaPie = _margenPie + _altoPie;

    // Con el teclado fuera, la zona desplazable llega **justo hasta su borde**.
    // Antes se le restaba además el pie, y quedaba una franja muerta de 50 px
    // sobre el teclado: la pantalla se veía cortada, como con un margen encima
    // del teclado. El logo del pie queda tapado por el teclado, así que no hay
    // que reservarle sitio mientras está abierto.
    final reservaInferior = teclado > 0
        ? teclado
        : barraNavegacion + reservaPie;

    return Stack(
      children: [
        // Fondo a sangre: pasa por detrás de la barra de estado y no se mueve.
        Positioned.fill(
          child: Image.asset(Images.backgroundInicio, fit: BoxFit.cover),
        ),

        // Lo único que se desplaza cuando sale el teclado.
        Positioned(
          top: barraEstado,
          left: 0,
          right: 0,
          bottom: reservaInferior,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: espacioSuperior),

                  SvgPicture.asset(Images.logoApp, width: 65, height: 74),

                  const SizedBox(height: 20),

                  Text(
                    'Eventos Esri',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.bold,
                      fontSize: 40,
                      height: 48 / 40,
                      color: AppColors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  child,

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),

        // Pie fijo.
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(bottom: barraNavegacion + _margenPie),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                Images.esriBlanco,
                width: 158,
                cacheWidth: 640,
              ),
            ),
          ),
        ),

        // Aviso fijo: el logo y la tarjeta se deslizan por detrás.
        if (aviso != null)
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.only(top: barraEstado + _avisoTop),
              child: Align(alignment: Alignment.topCenter, child: aviso!),
            ),
          ),
      ],
    );
  }
}
