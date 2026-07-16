import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 3.5), // Gap total de 7px
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? const Color(0xFF007AC2)
            : const Color(0xFFD9D9D9),
      ),
    );
  }
}