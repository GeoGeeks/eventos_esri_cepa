import 'package:flutter/material.dart';

const Color kNavBg = Color(0xFF091F44);
const Color kWhite = Colors.white;
const String kFont = 'AvenirNextLTPro';

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
      height: 80,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              color: kNavBg,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _NavButton(
                icon: Icons.home_outlined,
                label: 'Inicio',
                active: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavButton(
                icon: Icons.history,
                label: 'Historial',
                active: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _FabItem(
                active: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavButton(
                icon: Icons.notifications_none,
                label: 'Alertas',
                active: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavButton(
                icon: Icons.person_outline,
                label: 'Perfil',
                active: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        height: 56,
        decoration: BoxDecoration(
          color: active ? kWhite.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kWhite, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontFamily: kFont,
                fontSize: 11,
                color: kWhite,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _FabItem({
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent, // ← fix: captura tap aunque el círculo sobresalga
      child: SizedBox(
        width: 72,
        height: 80,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: -20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? kNavBg : kWhite,
                  border: active
                      ? Border.all(color: kWhite, width: 2.5)
                      : null,
                  boxShadow: active
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: active ? kWhite : kNavBg,
                  size: 24,
                ),
              ),
            ),
            const Positioned(
              bottom: 22,
              child: Text(
                'Reservas',
                style: TextStyle(
                  fontFamily: kFont,
                  fontSize: 11,
                  color: kWhite,
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