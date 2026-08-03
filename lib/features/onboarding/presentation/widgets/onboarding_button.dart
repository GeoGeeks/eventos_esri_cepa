import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';

class OnboardingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: const Color(0xFF007AC2),
          foregroundColor: const Color(0xFFF7F7F7),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          minimumSize: const Size(360, 44),
          maximumSize: const Size(360, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: Fonts.medium,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            height: 20 / 16,
            color: Color(0xFFF7F7F7),
          ),
        ),
      ),
    );
  }
}
