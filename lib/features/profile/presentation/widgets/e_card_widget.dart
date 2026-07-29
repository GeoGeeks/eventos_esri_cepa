import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../data/ecard_mock_data.dart';
import '../../data/ecard_visibility_config.dart';

class ECardWidget extends StatelessWidget {
  final ECardVisibilityConfig visibilityConfig;

  const ECardWidget({
    super.key,
    required this.visibilityConfig,
  });

  String _buildVCard() {
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCARD')
      ..writeln('VERSION:3.0')
      ..writeln('N:;${EcardMockData.nombre};;;')
      ..writeln('FN:${EcardMockData.nombre}');

    if (visibilityConfig.cargo) {
      buffer.writeln('TITLE:${EcardMockData.cargo}');
    }
    if (visibilityConfig.empresa) {
      buffer.writeln('ORG:${EcardMockData.empresa}');
    }
    if (visibilityConfig.correo) {
      buffer.writeln('EMAIL;TYPE=INTERNET:${EcardMockData.correo}');
    }
    if (visibilityConfig.telefono) {
      buffer.writeln('TEL;TYPE=CELL:${EcardMockData.telefono}');
    }

    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Construimos la línea de subtítulo dinámicamente según la visibilidad configurada
    final List<String> subtitleParts = [];
    if (visibilityConfig.cargo) subtitleParts.add(EcardMockData.cargo);
    if (visibilityConfig.empresa) subtitleParts.add(EcardMockData.empresa);
    final String subtitleText = subtitleParts.join(' · ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Avatar con Iniciales
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'ML',
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Nombre Principal
          const Text(
            EcardMockData.nombre,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
              height: 1.2,
            ),
          ),

          /// Subtítulo Dinámico (Cargo · Empresa)
          if (subtitleText.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSubtle,
                height: 1.3,
              ),
            ),
          ],

          const SizedBox(height: 24),

          /// Código QR Generado con vCard
          QrImageView(
            data: _buildVCard(),
            version: QrVersions.auto,
            size: 180,
            gapless: false,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.primary,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.primary,
            ),
            embeddedImage: const AssetImage(Images.logoqr),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }
}