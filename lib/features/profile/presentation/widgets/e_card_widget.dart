import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';

class ECardWidget extends StatelessWidget {
  const ECardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar azul con iniciales
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'ML',
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'María López',
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'Ingeniera Civil · Procalculo',
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSubtle,
            ),
          ),

          const SizedBox(height: 24),

          // QR real
          Image.asset(
            Images.qrEcard,
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}