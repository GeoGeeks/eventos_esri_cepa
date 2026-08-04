import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/app_icons.dart';
import '../../profile/data/ecard_mock_data.dart';
import '../data/credencial_mock_data.dart';

class CredencialModal extends StatelessWidget {
  final CredencialData datos;

  const CredencialModal({super.key, required this.datos});

  static CredencialData get datosPorDefecto => const CredencialData(
    nombre: EcardMockData.nombre,
    cargo: EcardMockData.cargo,
    empresa: EcardMockData.empresa,
    evento: CredencialMockData.evento,
    codigo:
        '${CredencialMockData.codigoEvento}-${EcardMockData.documento}',
  );

  static Future<void> mostrar(BuildContext context, {CredencialData? datos}) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Credencial digital',
      barrierColor: AppColors.modalOverlay,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) =>
          CredencialModal(datos: datos ?? datosPorDefecto),
      transitionBuilder: (_, animation, _, child) {
        final curva = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curva),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 581,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.lightGray),
              left: BorderSide(color: AppColors.lightGray),
              right: BorderSide(color: AppColors.lightGray),
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(-1, -1),
                blurRadius: 32,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 24.5,
                right: 23.5,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: AppIcon(
                        SvgIcon.x,
                        width: 9,
                        height: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 48,
                left: 24,
                right: 24,
                height: 452,
                child: _Contenido(datos: datos),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  final CredencialData datos;

  const _Contenido({required this.datos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 32,
          child: Text(
            'Credencial digital',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.text3h,
              fontWeight: Fonts.wMedium,
              height: 32 / 26,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const SizedBox(
          height: 20,
          child: Text(
            'Utilice este código para acceder al evento',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wRegular,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 61.5),
        SizedBox(
          height: 32,
          child: Text(
            datos.nombre,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: Fonts.demi,
              fontSize: Fonts.text3h,
              fontWeight: Fonts.wDemi,
              height: 32 / 26,
              letterSpacing: 0,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 2.5),
        SizedBox(
          height: 20,
          child: Text(
            datos.subtitulo,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: Fonts.regular,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wRegular,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.modalSubtitle,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: QrImageView(
            data: datos.codigo,
            version: QrVersions.auto,
            size: 232,
            gapless: false,
            backgroundColor: AppColors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.qrCredencial,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.qrCredencial,
            ),
            embeddedImage: const AssetImage(Images.logoqr),
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(40, 40),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Text(
            datos.evento,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wMedium,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
