import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../../login/data/perfil_usuario.dart';
import '../../data/ecard_mock_data.dart';
import '../../data/ecard_visibility_config.dart';

class ECardWidget extends StatelessWidget {
  final ECardVisibilityConfig visibilityConfig;

  /// Perfil autenticado real - `null` deja el comportamiento mock de
  /// siempre (`EcardMockData`), que es lo que usan los tests de layout que
  /// montan este widget sin `AuthCubit` autenticado. Ver
  /// `ECardScreen._ECardScreenState.build`.
  final PerfilUsuario? perfil;

  const ECardWidget({
    super.key,
    required this.visibilityConfig,
    this.perfil,
  });

  String get _nombre => perfil?.nombreCompleto ?? EcardMockData.nombre;
  String get _iniciales => perfil?.iniciales ?? 'ML';

  /// `cargo`/`organizacion` del perfil real son opcionales (no toda
  /// inscripción los trae) - a diferencia de `EcardMockData`, que siempre
  /// tiene un valor fijo, en modo real se dejan en `null` en vez de rellenar
  /// con el mock, para no mezclar un dato real con uno inventado.
  String? get _cargo => perfil != null ? perfil!.cargo : EcardMockData.cargo;
  String? get _empresa =>
      perfil != null ? perfil!.organizacion : EcardMockData.empresa;
  String get _correo => perfil?.email ?? EcardMockData.correo;
  String get _telefono => perfil?.celular ?? EcardMockData.telefono;

  String _buildVCard() {
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCARD')
      ..writeln('VERSION:3.0')
      ..writeln('N:;$_nombre;;;')
      ..writeln('FN:$_nombre');

    if (visibilityConfig.cargo && _cargo != null && _cargo!.isNotEmpty) {
      buffer.writeln('TITLE:$_cargo');
    }
    if (visibilityConfig.empresa && _empresa != null && _empresa!.isNotEmpty) {
      buffer.writeln('ORG:$_empresa');
    }
    if (visibilityConfig.correo) {
      buffer.writeln('EMAIL;TYPE=INTERNET:$_correo');
    }
    if (visibilityConfig.telefono) {
      buffer.writeln('TEL;TYPE=CELL:$_telefono');
    }

    buffer.writeln('END:VCARD');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> subtitleParts = [];
    if (visibilityConfig.cargo && _cargo != null && _cargo!.isNotEmpty) {
      subtitleParts.add(_cargo!);
    }
    if (visibilityConfig.empresa && _empresa != null && _empresa!.isNotEmpty) {
      subtitleParts.add(_empresa!);
    }
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
                color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.lightGray, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Frame 1 (Nombre y Subtítulo con gap: 2px)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Nombre real del asistente (24px Bold #007AC2, line-height 20/24)
                      Text(
                        _nombre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 20 / 24,
                          color: AppColors.primary,
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
                            color: AppColors.modalSubtitle,
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
                    backgroundColor: AppColors.white,
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
            ),
          ),

          /// Avatar (74x74px del CSS, radio 4 -> cuadrado redondeado,
          /// NO circular). Color exacto #D6EFFF (antes tenía un typo:
          /// D6EEFF).
          Positioned(
            top: 0,
            child: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: AppColors.chipBg,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                _iniciales,
                style: const TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 20 / 32,
                  color: AppColors.modalSubtitle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
