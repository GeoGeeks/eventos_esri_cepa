import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';

/// Confirmación tras enviar una encuesta `modulo` - misma estructura visual
/// que `ValoracionSuccessDialog` (barra verde + header + contenido +
/// footer), pero genérica: cierra de vuelta a la pestaña "Encuestas" en vez
/// de navegar al certificado, que solo aplica a la encuesta `post_evento`.
class EncuestaSuccessDialog extends StatelessWidget {
  const EncuestaSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: -4,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 4,
              spreadRadius: -2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 360, height: 4, color: AppColors.success),
            Container(
              width: 360,
              height: 53,
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGray, width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Row(
                children: [
                  AppIcon(
                    SvgIcon.calificacionevento,
                    width: 16,
                    height: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '¡Gracias por su respuesta!',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontWeight: Fonts.wMedium,
                        fontSize: 20,
                        height: 24 / 20,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: AppIcon(
                          SvgIcon.x,
                          width: 8,
                          height: 8,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 360,
              height: 84,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Su respuesta fue registrada correctamente.',
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontWeight: Fonts.wRegular,
                    fontSize: Fonts.text0h,
                    height: 20 / 16,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
            ),
            Container(
              width: 360,
              height: 57,
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  top: BorderSide(color: AppColors.lightGray, width: 1),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerRight,
                child: IntrinsicWidth(
                  child: SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        elevation: 0,
                      ),
                      // Pop del diálogo Y de la pantalla de la encuesta: dos
                      // pops porque `EncuestaResponderScreen` sigue en la
                      // pila debajo de este diálogo (a diferencia de
                      // `ValoracionSuccessDialog`, que reemplaza toda la
                      // pila con `pushAndRemoveUntil`).
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cerrar',
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontWeight: Fonts.wRegular,
                          fontSize: 14,
                          height: 16 / 14,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
