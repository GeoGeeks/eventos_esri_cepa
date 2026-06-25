import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF9E9E9E),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: Fonts.avenir,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9E9E9E),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}