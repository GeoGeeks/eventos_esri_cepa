import 'package:flutter/material.dart';

class ECardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ECardActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 81,
        height: 59,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFEBEBEB), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Icono 16x16px
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF007AC2),
            ),

            /// Gap exacto de 4px (según Figma)
            const SizedBox(height: 4),

            /// Texto "Hug" natural con alineación limpia
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'Inter', // O la constante Fonts.regular / Fonts.medium que uses
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 15 / 12, // 125% line-height = 15px
                color: Color(0xFF007AC2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


