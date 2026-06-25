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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFFF4D4F)),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: const Text(
            'Cerrar Sesión',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              color: Color(0xFFFF4D4F),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}