import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class AgendaItemCard extends StatelessWidget {
  final String title;
  final String time;
  final String location;

  const AgendaItemCard({
    super.key,
    required this.title,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: const Color(0xFFEAEAEA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.star_border,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: AppColors.textSubtle,
              ),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.textSubtle,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSubtle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}