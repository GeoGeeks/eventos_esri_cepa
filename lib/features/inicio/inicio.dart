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
  final VoidCallback? onGoToNotifications;

  const InicioApp({super.key, this.onGoToNotifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // background: #F7F7F7
      body: Column(
        children: [
          // 1. HEADER CON BOTÓN ABSOLUTO CORRECTO
          _Header(onGoToNotifications: onGoToNotifications),

          // 2. CUERPO CON SCROLL INDEPENDIENTE (Asegura que se vean todas las tarjetas abajo)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 360, // Limita al ancho exacto del Frame 1420
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Título Sección 1
                      const _SectionTitle(title: 'Eventos reservados'),
                      const SizedBox(height: 12), // gap: 12px

                      // Carrusel Horizontal
                      _HorizontalCarousel(
                        itemCount: _reservedEvents.length,
                        itemWidth: 237,
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

                      const SizedBox(height: 24),

                      // Título Sección 2 con botón "Ver todos"
                      _SectionTitle(
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

                      const SizedBox(height: 12), // gap: 12px

                      // Listado vertical de tarjetas Próximos Eventos
                      ..._upcomingEvents.map(
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
                      ),

                      const SizedBox(height: 24), // Espacio extra inferior
                    ],
                  ),
                ),
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
  final VoidCallback? onGoToNotifications;

  const _Header({this.onGoToNotifications});

  @override
  Widget build(BuildContext context) {
    // Tomamos la altura del área segura (Notch/Status Bar) para que no tape el contenido
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      // Altura del Header según Figma (120px) + la barra de estado del celular
      height: 120 + statusBarHeight,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        image: DecorationImage(
          image: AssetImage(Images.headerInicio),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: 120, // Altura neta del contenido del Header
          child: Stack(
            children: [
              // 1. TEXTOS DE BIENVENIDA (Alineados a la izquierda a 26px del borde)
              Positioned(
                left: 26,
                top: 26, // top aproximado para centrar verticalmente con la campana
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenida',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'María López',
                      style: TextStyle(
                        fontFamily: Fonts.bold,
                        color: AppColors.white,
                        fontSize: 32, // font-size: 32px de Figma
                        fontWeight: FontWeight.w700,
                        height: 1.25, // line-height: 40px
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ingeniera Civil · Procalculo',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        color: const Color(0xFFD6EFFF), // color: #D6EFFF
                        fontSize: 14,
                        height: 1.14, // line-height: 16px
                      ),
                    ),
                  ],
                ),
              ),

              // 2. CAMPANA DE ALERTAS EN POSICIÓN EXACTA DE FIGMA
              // left: 346px de un plano de 412px de ancho equivale a estar a 26px del borde derecho (right: 26)
              // top: 30px del CSS de Figma
              Positioned(
                right: 26,
                top: 30,
                child: _NotificationBell(
                  onTap: onGoToNotifications,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final VoidCallback? onTap;

  const _NotificationBell({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, // width: 40px en CSS
        height: 40, // height: 40px en CSS
        decoration: const BoxDecoration(
          color: AppColors.white, // background: #FFFFFF
          shape: BoxShape.circle,
          // Traduciendo el drop-shadow(1px 2px 4px rgba(0, 0, 0, 0.3)) de Figma
          boxShadow: [
            BoxShadow(
              color: Color(0x4D000000), // Opacidad de 30% (0x4D) sobre negro
              blurRadius: 4,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.notifications_none,
              color: AppColors.primary,
              size: 22,
            ),
            // Indicador de notificación rojo
            Positioned(
              top: 10,
              right: 11,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.notification,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
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
            fontSize: 18, // font-size: 18px del CSS
            fontWeight: FontWeight.w500, // font-weight: 500
            color: Color(0xFF141414), // color: #141414
            height: 24 / 18, // line-height: 24px
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
          color: AppColors.chipBg,
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
      width: 360, // Sincroniza con el ancho de Figma
      height: 262, // 257px de altura + 5px de tolerancia para sombras
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 24), // gap: 24px del CSS
        itemBuilder: (context, index) =>
            SizedBox(width: itemWidth, child: itemBuilder(context, index)),
      ),
    );
  }
}
