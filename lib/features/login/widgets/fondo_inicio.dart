// lib/features/login/widgets/fondo_inicio.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';

class FondoInicio extends StatelessWidget {
  const FondoInicio({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Positioned.fill(
          child: SvgPicture.asset(
            Images.backgroundInicio,
            fit: BoxFit.cover,
          ),
        ),

        SafeArea(
          child: Column(
            children: [

              const SizedBox(height: 28),

              SvgPicture.asset(
                Images.logoApp,
                width: 72,
              ),

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

              const Spacer(),

              child,

              const Spacer(),

              SvgPicture.asset(
                Images.esriBlanco,
                width: 160,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}