import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';

class OnboardingContent extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Círculo gris
            Positioned(
              top: 90,
              left: (constraints.maxWidth - 350) / 2,
              child: Container(
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Imagen
            Positioned(
              top: 95,
              left: (constraints.maxWidth - 295) / 2,
              child: SizedBox(
                width: 295,
                height: 376,
                child: Image.asset(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Título + descripción
            Positioned(
              top: 545,
              left: (constraints.maxWidth - 360) / 2,
              child: SizedBox(
                width: 360,
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF141414),
                        height: 32 / 26,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B6B6B),
                        height: 20 / 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}