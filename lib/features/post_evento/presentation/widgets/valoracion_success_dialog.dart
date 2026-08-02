import 'package:flutter/material.dart';

// Constantes globales de tu arquitectura
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../navigation/menu.dart';

class ValoracionSuccessDialog extends StatelessWidget {
  const ValoracionSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
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
            /// highlight superior (verde)
            Container(
              width: 360,
              height: 4,
              color: const Color(0xFF288835),
            ),

            /// header (360x53, borde inferior #EBEBEB)
            Container(
              width: 360,
              height: 53,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              child: Row(
                children: [
                  /// check-circle 16x16 (icono: calificacionevento)
                  AppIcon(
                    SvgIcon.calificacionevento,
                    width: 16,
                    height: 16,
                    color: const Color(0xFF288835),
                  ),
                  const SizedBox(width: 12),

                  /// Panel heading
                  const Expanded(
                    child: Text(
                      '¡Gracias por tu valoración!',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontWeight: Fonts.wMedium,
                        fontSize: 20,
                        height: 24 / 20,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),

                  /// action-container 40x40 con icono "x": lleva a inicio
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: AppIcon(
                          SvgIcon.x,
                          width: 8,
                          height: 8,
                          color: const Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// panel-content (360x84, padding 12, overflow-y scroll)
            SizedBox(
              width: 360,
              height: 84,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontWeight: Fonts.wRegular,
                      fontSize: Fonts.text0h,
                      height: 20 / 16,
                      color: Color(0xFF141414),
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Ya puede acceder a su certificado de asistencia '
                            'y revivir los mejores momentos de la ',
                      ),
                      TextSpan(
                        text: 'CUE 2026',
                        style: TextStyle(
                          fontFamily: Fonts.demi,
                          fontWeight: Fonts.wDemi,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),

            /// footer (360x57, padding 12, borde superior #EBEBEB)
            Container(
              width: 360,
              height: 57,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                border: Border(
                  top: BorderSide(color: Color(0xFFEBEBEB), width: 1),
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 127,
                  height: 32,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AC2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // cerrar popup
                      Navigator.pop(context);
                      // cerrar paso2
                      Navigator.pop(context);
                      // cerrar paso1
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Ir a mis eventos',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontWeight: Fonts.wRegular,
                        fontSize: 14,
                        height: 16 / 14,
                        color: Color(0xFFFFFFFF),
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
