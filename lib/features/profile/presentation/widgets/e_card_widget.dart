import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
    final List<String> subtitleParts = [];
    if (visibilityConfig.cargo) subtitleParts.add(EcardMockData.cargo);
    if (visibilityConfig.empresa) subtitleParts.add(EcardMockData.empresa);
    final String subtitleText = subtitleParts.join(' - ');

    return SizedBox(
      width: 360,
      height: 445,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          /// Card blanca principal (Rectangle 8 CSS: 360x406px)
          Positioned(
            top: 37,
            child: Container(
              width: 360,
              height: 406,
              padding: const EdgeInsets.only(top: 45, left: 16, right: 16, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Frame 1 (Nombre y Subtítulo con gap: 2px)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// María López (24px Bold #007AC2)
                      const Text(
                        EcardMockData.nombre,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 20 / 24,
                          color: Color(0xFF007AC2),
                        ),
                      ),
                      if (subtitleText.isNotEmpty) ...[
                        const SizedBox(height: 2), // gap: 2px del CSS
                        Text(
                          subtitleText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 20 / 16,
                            color: Color(0xFF4A4A4A),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Código QR (232x232px del CSS)
                  QrImageView(
                    data: _buildVCard(),
                    version: QrVersions.auto,
                    size: 232,
                    gapless: false,
                    backgroundColor: Colors.white,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Color(0xFF007AC2),
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF007AC2),
                    ),
                    embeddedImage: const AssetImage(Images.logoqr),
                    embeddedImageStyle: const QrEmbeddedImageStyle(
                      size: Size(36, 36),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Avatar (74x74px del CSS)
          Positioned(
            top: 0,
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFD6EEFF),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: const Text(
                'ML',
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 20 / 32,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
