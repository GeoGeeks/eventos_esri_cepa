import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import 'button_cards.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final VoidCallback onViewMore;
  final VoidCallback onCredential;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.onViewMore,
    required this.onCredential,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.08),
    blurRadius: 6,
    offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                    height: 24 / 20,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.access_time_outlined, text: date),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.location_on_outlined, text: location),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Ver más',
                        onPressed: onViewMore,
                        variant: ButtonCardsVariant.outlined,
                        height: 36,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        label: 'Mi credencial',
                        onPressed: onCredential,
                        height: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSubtle),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSubtle,
              height: 16 / 14,
              letterSpacing: 0,
            ),
          ),
        ),
      ],
    );
  }
}