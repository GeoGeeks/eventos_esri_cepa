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
      margin: const EdgeInsets.symmetric(horizontal: 3.5),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF091F44)
            : const Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
    );
  }
}