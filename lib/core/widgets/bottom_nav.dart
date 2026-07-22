import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [

          /// Barra azul
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                border: Border(
                  top: BorderSide(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),

          /// Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              _NavButton(
                icon: Icons.home_outlined,
                label: "Inicio",
                active: currentIndex == 0,
                onTap: () => onTap(0),
              ),

              _NavButton(
                icon: Icons.history,
                label: "Historial",
                active: currentIndex == 1,
                onTap: () => onTap(1),
              ),

              const SizedBox(width: 60),

              _NavButton(
                icon: Icons.notifications_none,
                label: "Alertas",
                active: currentIndex == 3,
                onTap: () => onTap(3),
              ),

              _NavButton(
                icon: Icons.person_outline,
                label: "Perfil",
                active: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),

          /// Botón central
          Positioned(
            top: -14,
            child: _ReservasButton(
              active: currentIndex == 2,
              onTap: () => onTap(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54,
        height: 52,
        decoration: BoxDecoration(
          color: active
              ? AppColors.navActiveHighlight
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              color: AppColors.white,
              size: 24,
            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 12,
                height: 1,
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReservasButton extends StatelessWidget {

  final bool active;
  final VoidCallback onTap;

  const _ReservasButton({
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: SizedBox(
        width: 60,
        height: 84,
        child: Column(
          children: [

            AnimatedContainer(
              duration: const Duration(milliseconds: 180),

              width: 60,
              height: 60,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.navActiveReservas
                    : AppColors.white,

                border: active
                    ? Border.all(
                        color: AppColors.white,
                        width: 1,
                      )
                    : null,

                boxShadow: active
                    ? null
                    : const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 3),
                        ),
                      ],
              ),

              child: Icon(
                Icons.calendar_today_outlined,
                size: 24,
                color: active
                    ? AppColors.white
                    : AppColors.primary,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Reservas",
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 12,
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}