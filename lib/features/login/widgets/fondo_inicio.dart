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

        
        SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
              
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        const SizedBox(height: 160),

                        SvgPicture.asset(
                          Images.logoApp,
                          width: 65,
                          height: 74,
                        ),

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
