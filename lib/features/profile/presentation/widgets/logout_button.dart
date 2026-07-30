import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFD83020);

    return SizedBox(
      width: 362, // ✅ Ancho exacto de Figma
      height: 44, // ✅ Altura exacta de Figma
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          splashColor: primaryRed.withOpacity(0.12),
          highlightColor: primaryRed.withOpacity(0.06),
          borderRadius: BorderRadius.circular(0.001),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco (revisar si aplica según diseño final)
              border: Border.all(
                color: primaryRed, // Borde Rojo (#D83020)
                width: 1,
              ),
              borderRadius: BorderRadius.circular(0.001),
            ),
            child: const Center(
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: primaryRed, 
                  height: 1.25, // ✅ line-height 20px (125%)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
