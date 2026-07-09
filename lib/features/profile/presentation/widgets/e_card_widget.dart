import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
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
                fontFamily: Fonts.avenir,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'María López',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Ingeniera Civil · Procalculo',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSubtle,
            ),
          ),

          const SizedBox(height: 24),

          QrImageView(
            data: _buildVCard(),
            version: QrVersions.auto,
            size: 180,
            gapless: false,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.primary,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}