import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';

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
    return MediaQuery(
      // Evita que el ajuste de tamaño de fuente del sistema
      // rompa el layout fijo de la barra inferior.
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.noScaling,
      ),
      child: Container(
        height: 70,
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            /// Barra azul de fondo
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

            /// Botones — centrados verticalmente dentro de los 70px
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _NavButton(
                        icon: SvgIcon.inicio,
                        label: "Inicio",
                        active: currentIndex == 0,
                        onTap: () => onTap(0),
                      ),

                      _NavButton(
                        icon: SvgIcon.historial,
                        label: "Historial",
                        active: currentIndex == 1,
                        onTap: () => onTap(1),
                      ),

                      const SizedBox(width: 64),

                      _NavButton(
                        icon: SvgIcon.alertas,
                        label: "Alertas",
                        active: currentIndex == 3,
                        onTap: () => onTap(3),
                      ),

                      _NavButton(
                        icon: SvgIcon.perfil,
                        label: "Perfil",
                        active: currentIndex == 4,
                        onTap: () => onTap(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Botón central Reservas — flota sobre la barra
            Positioned(
              top: -32,
              child: _ReservasButton(
                active: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String icon;
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 54,
          height: 52,
          decoration: BoxDecoration(
            color: active
                ? AppColors.navActiveHighlight
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppIcon(
                icon,
                width: 24,
                height: 24,
                color: AppColors.white,
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 12,
                  height: 20 / 12,
                  letterSpacing: 0,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? AppColors.navActiveReservas
                    : AppColors.white,
                border: Border.all(
                  color: AppColors.lightGray,
                  width: 1,
                ),
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
              child: Center(
                child: AppIcon(
                  SvgIcon.reservas,
                  width: 24,
                  height: 24,
                  color: active
                      ? AppColors.white
                      : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(
              width: 49,
              height: 20,
              child: Text(
                "Reservas",
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 12,
                  height: 20 / 12,
                  letterSpacing: 0,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
