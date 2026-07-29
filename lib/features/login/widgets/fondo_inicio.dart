// lib/features/login/widgets/fondo_inicio.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';

class FondoInicio extends StatelessWidget {
  const FondoInicio({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(Images.backgroundInicio, fit: BoxFit.cover),
        ),

        // Los paneles de estas pantallas superan la altura del viewport a
        // 412x917: Soporte desbordaba 117 px y su botón "Enviar" quedaba
        // fuera de pantalla, sin forma de pulsarlo.
        //
        // Se evita a propósito el patrón Spacer + IntrinsicHeight: el
        // TextField de 5 líneas de Soporte declara una altura intrínseca de
        // una sola línea y el cálculo se queda 60 px corto.
        //
        // En su lugar: cabecera y pie fijos, y el panel en un área que se
        // desplaza solo si no cabe. Cuando cabe, queda centrado igual que antes.
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 28),

              SvgPicture.asset(Images.logoApp, width: 72),

              const SizedBox(height: 18),

              Text(
                'Eventos Esri',
                style: TextStyle(
                  fontFamily: Fonts.bold,
                  fontSize: 40,
                  height: 48 / 40,
                  color: AppColors.white,
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: child),
                  ),
                ),
              ),

              // El PNG original mide 4096x674 para mostrarse a 158 px de
              // ancho. cacheWidth lo decodifica al tamaño que realmente se
              // usa y evita reservar ~11 MB de mapa de bits por pantalla.
              Image.asset(
                Images.esriBlanco,
                width: 158,
                cacheWidth: 640,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
