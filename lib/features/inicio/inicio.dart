import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/event_card.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../invitados/invitados.dart';
import '../eventos/eventos_screen.dart';

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
    date: 'Oct 01 - 08:00 a.m.',
    location: 'Ágora, Bogotá',
    image: Images.esriEventos,
  ),
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
    title: 'Planeta Esri Villavicencio',
    date: 'Ago 20 - 08:00 a.m.',
    location: 'Universidad de los Llanos',
    image: Images.planetaEsri,
    mode: 'Presencial',
  ),
  _UpcomingEvent(
    title: 'Planeta Esri Bogotá',
    date: 'Sept 10 - 08:00 a.m.',
    location: 'Universidad Central',
    image: Images.planetaEsri,
    mode: 'Presencial',
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
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // 1. HEADER (136px + status bar)
          const _Header(),

          // 2. CUERPO CON SCROLL INDEPENDIENTE
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Título Sección 1
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: _SectionTitle(title: 'Eventos reservados'),
                  ),
                  const SizedBox(height: 12),

                  // Carrusel Horizontal
                  SizedBox(
                    height: 262,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _reservedEvents.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final e = _reservedEvents[index];
                        return SizedBox(
                          width: 237,
                          child: EventCard(
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
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Título Sección 2 con botón "Ver todos"
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _SectionTitle(
                      title: 'Próximos eventos',
                      action: _SeeAllChip(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EventosScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Listado vertical de tarjetas Próximos Eventos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: _upcomingEvents
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
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
                          )
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SUBWIDGETS ---

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      // Altura exacta del banner (136px) sumando la barra de estado superior
      height: 136 + statusBarHeight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        image: DecorationImage(
          image: AssetImage(Images.headerInicio),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Frame 1464: Textos (left: 24px, top: 30px)
              Positioned(
                left: 24,
                top: 30,
                width: 193,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    // Bienvenido (width: 83, height: 20)
                    Text(
                      'Bienvenida',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFFFFFFF),
                        height: 20 / 14,
                      ),
                    ),
                    // María López + Subtítulo (_Body)
                    Text(
                      'María López',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFFFFF),
                        height: 40 / 32,
                      ),
                    ),
                    Text(
                      'Ingeniera Civil - Procalculo',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFD6EFFF),
                        height: 16 / 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Alertas (Campana): left: 346px, top: 30px
              const Positioned(
                left: 346,
                top: 30,
                child: _NotificationBell(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Base circular blanca con sombra paralela (1px, 2px, blur 4, 30%)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x4D000000), // #000000 al 30%
                  blurRadius: 4,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),

          // Icono campana (24x24 px, Azul #007AC2)
          const Center(
            child: Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF007AC2),
              size: 24,
            ),
          ),

          // Ellipse 6: Punto indicador rojo (#D83020) de 8.65px x 8.65px
          // Delta exacto Figma: (367.62 - 346 = 21.62px left | 41.89 - 30 = 11.89px top)
          Positioned(
            left: 21.62,
            top: 11.89,
            child: Container(
              width: 8.65,
              height: 8.65,
              decoration: const BoxDecoration(
                color: Color(0xFFD83020),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: Fonts.medium,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF141414),
            height: 24 / 18,
          ),
        ),
        if (action != null) action!,
      ],
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
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Ver todos',
          style: TextStyle(
            fontFamily: Fonts.medium,
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

