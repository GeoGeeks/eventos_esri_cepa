import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: Fonts.avenir,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202020),
          ),
        ),
      ),
    );
  }
}