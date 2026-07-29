// lib/features/login/widgets/login_input.dart

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class LoginInput extends StatelessWidget {
  const LoginInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefixIcon,
  });

  final String label;
  final String hint;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 14,
            color: AppColors.textTitle,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,

          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 15,
            color: AppColors.textTitle,
          ),

          decoration: InputDecoration(

            prefixIcon: prefixIcon,

            hintText: hint,

            hintStyle: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 15,
              color: AppColors.textSubtle,
            ),

            filled: true,
            fillColor: AppColors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2),
              borderSide: const BorderSide(
                color: AppColors.inputBorder,
              ),
            ),

            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 1.3,
              ),
            ),

            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.requiredField,
              ),
            ),

            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.requiredField,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}