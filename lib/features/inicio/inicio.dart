import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/event_card.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../invitados/invitados.dart';

class _ReservedEvent {
  final String title, date, location, image;

  const _ReservedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
  });
}

class _UpcomingEvent {
  final String title, date, location, image, mode;

  const _UpcomingEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
  });
}

const _reservedEvents = [
  _ReservedEvent(
    title: 'CUE 2026',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Ágora Bogotá',
    image: Images.esriEventos,
  ),
  _ReservedEvent(
    title: 'CUE 2026',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Ágora Bogotá',
    image: Images.esriEventos,
  ),
];

const _upcomingEvents = [
  _UpcomingEvent(
    title: 'Planeta Esri',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.planetaEsri,
    mode: 'Presencial',
  ),
  _UpcomingEvent(
    title: 'Planeta Esri',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.planetaEsri,
    mode: 'Virtual',
  ),
  _UpcomingEvent(
    title: 'Planeta Esri',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.planetaEsri,
    mode: 'Presencial',
  ),
];

class InicioApp extends StatelessWidget {
  const InicioApp({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 20),

          _SectionTitle(title: 'Eventos reservados'),
          const SizedBox(height: 14),

          _HorizontalCarousel(
            itemCount: _reservedEvents.length,
            itemWidth: 260,
            itemBuilder: (context, i) {
              final e = _reservedEvents[i];

              return EventCard(
                title: e.title,
                date: e.date,
                location: e.location,
                image: e.image,
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InvitadosScreen(),
                    ),
                  );
                },
                onCredential: () {},
              );
            },
          ),

          const SizedBox(height: 20),

          _SectionTitle(
            title: 'Próximos eventos',
            action: _SeeAllChip(
              onTap: () {},
            ),
          ),

          const SizedBox(height: 14),

          ..._upcomingEvents.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: UpcomingEventCard(
                title: e.title,
                date: e.date,
                location: e.location,
                image: e.image,
                mode: e.mode,
                onViewMore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InvitadosScreen(),
                    ),
                  );
                },
                onRegister: () {},
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
}
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 165,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        image: DecorationImage(
          image: AssetImage(Images.headerInicio),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenida',
                      style: TextStyle(
                        fontFamily: Fonts.avenir,
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'María López',
                      style: TextStyle(
                        fontFamily: Fonts.avenir,
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Ingeniera Civil · Procalculo',
                      style: TextStyle(
                        fontFamily: Fonts.avenir,
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              _NotificationBell(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.white.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_none,
            color: AppColors.primary,
            size: 26,
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: AppColors.notification,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionTitle({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

class _SeeAllChip extends StatelessWidget {
  final VoidCallback onTap;

  const _SeeAllChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.chipBg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Ver todos',
          style: TextStyle(
            fontFamily: Fonts.avenir,
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HorizontalCarousel extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final Widget Function(BuildContext, int) itemBuilder;

  const _HorizontalCarousel({
    required this.itemCount,
    required this.itemWidth,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) =>
            SizedBox(width: itemWidth, child: itemBuilder(context, index)),
      ),
    );
  }
}
