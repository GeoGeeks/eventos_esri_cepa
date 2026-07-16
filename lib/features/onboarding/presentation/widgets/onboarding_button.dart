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
          backgroundColor: const Color(0xFF007AC2),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFF7F7F7),
            height: 20 / 16,
          ),
        ),
      ),
    );
  }
}