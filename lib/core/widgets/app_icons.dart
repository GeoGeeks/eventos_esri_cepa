import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_colors.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.width = 24,
    this.height = 24,
    this.color = AppColors.white,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
  });

  /// Ruta del SVG definida en AppIcons.
  final String icon;

  /// Ancho del ícono.
  final double width;

  /// Alto del ícono.
  final double height;

  /// Color del ícono.
  ///
  /// Valores comunes:
  /// - AppColors.white (por defecto)
  /// - AppColors.primary
  /// - AppColors.textSubtle
  /// - Colors.black
  ///
  /// Si es null se conserva el color original del SVG.
  final Color? color;

  /// Ajuste del SVG.
  final BoxFit fit;

  /// Alineación.
  final AlignmentGeometry alignment;

  /// Texto para accesibilidad.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      semanticsLabel: semanticLabel,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
    );
  }
}