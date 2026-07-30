// lib/features/login/widgets/error_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';

class ErrorBanner extends StatelessWidget {
  const ErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4F4),
        border: Border.all(color: AppColors.requiredField),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(SvgIcon.avisoBorde, width: 22, height: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 13,
                height: 1.4,
                color: AppColors.requiredField,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
