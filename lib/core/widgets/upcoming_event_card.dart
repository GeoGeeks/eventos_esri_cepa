import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import 'button_cards.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final String mode;
  final VoidCallback onViewMore;
  final VoidCallback onRegister;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
    required this.onViewMore,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 122.0;
    const double imageWidth = 138.0;

    return SizedBox(
      height: cardHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: AppColors.cardBg,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              SizedBox(
                width: imageWidth,
                child: Image.asset(
                  image,
                  width: imageWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),

              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontFamily: Fonts.avenir,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textTitle,
                                height: 22 / 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _ModeChip(label: mode),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _InfoRow(
                        icon: Icons.access_time_outlined,
                        text: date,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _InfoRow(
                        icon: Icons.location_on_outlined,
                        text: location,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppButton(
                            label: 'Ver más',
                            onPressed: onViewMore,
                            variant: ButtonCardsVariant.outlined,
                            height: 30,
                            fontSize: 13,
                          ),
                          const SizedBox(width: 8),
                          AppButton(
                            label: 'Registrarse',
                            onPressed: onRegister,
                            height: 30,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  const _ModeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: Fonts.avenir,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
          height: 16 / 11,
        ),
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
        Icon(icon, size: 14, color: AppColors.textSubtle),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textSubtle,
              height: 16 / 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}