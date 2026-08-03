import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  final double imageWidth;
  final double imageHeight;
  final double imageTop;
  final double imageOffsetX;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.imageWidth = 295,
    this.imageHeight = 376,
    this.imageTop = 169,
    this.imageOffsetX = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Ellipse 9 (Fondo gris circular: 350x350, top: 190px, left: calc(50% - 350px/2 + 5px))
        Positioned(
          top: 190,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: const Offset(5, 0),
            child: Center(
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),

        // 2. tarjeta_eventos_esri1 1 (Ilustración: 295x376, top: 169px, left: calc(50% - 295px/2 + 1.5px))
        Positioned(
          top: imageTop,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(imageOffsetX, 0),
            child: Center(
              child: Image.asset(
                image,
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // 3. Título + Descripción (Auto layout 360x86, gap: 14px, top: 617px)
        Positioned(
          top: 617,
          left: 0,
          right: 0,
          child: Center(
            child: SizedBox(
              width: 360,
              height: 86,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Eventos Esri (360x32, Avenir Medium 26px / line-height: 32px)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      height: 32 / 26,
                      color: Color(0xFF141414),
                    ),
                  ),

                  const SizedBox(height: 14), // gap: 14px

                  // Descripción (360x40, Avenir Regular 16px / line-height: 20px)
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 20 / 16,
                      color: Color(0xFF141414),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
