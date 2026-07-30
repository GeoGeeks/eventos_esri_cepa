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
    return SizedBox(
      width: 362,
      height: 20,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: Fonts.medium,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF141414),
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
