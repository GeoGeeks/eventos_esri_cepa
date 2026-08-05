import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/event_card.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../credencial/presentation/credencial_modal.dart';
import '../eventos/data/proximos_eventos_data.dart';
import '../invitados/invitados.dart';
import '../registro/presentation/registro_modal.dart';

class _ReservedEvent {
  final String title, date, location, image;

  const _ReservedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
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

/// Los «Próximos eventos» son los mismos de la pantalla Eventos: así el "Ver
/// más" de una tarjeta puede abrir el modal de detalle de ese mismo evento.
const _upcomingEvents = proximosEventosMock;

class InicioApp extends StatelessWidget {
  final VoidCallback? onGoToNotifications;

  /// Abre la pantalla Eventos. Con [ProximoEvento] no nulo, además superpone
  /// el modal de detalle de ese evento (la «ventana evento» del diseño).
  final void Function(ProximoEvento? evento)? onGoToEventos;

  const InicioApp({
    super.key,
    this.onGoToNotifications,
    this.onGoToEventos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Header(onGoToNotifications: onGoToNotifications),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const _SectionTitle(title: 'Eventos reservados'),
                      const SizedBox(height: 12),
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
                            // "Ver más" de un evento reservado → Invitados.
                            onViewMore: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const InvitadosScreen(),
                                ),
                              );
                            },
                            // "Mi credencial" → el modal de la credencial.
                            onCredential: () =>
                                CredencialModal.mostrar(context),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Próximos eventos',
                        action: _SeeAllChip(
                          onTap: () => onGoToEventos?.call(null),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._upcomingEvents.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: UpcomingEventCard(
                            title: e.titulo,
                            date: '${e.fecha} - ${e.hora}',
                            location: e.direccion,
                            image: e.image,
                            mode: e.presencial ? 'Presencial' : 'Virtual',
                            // "Ver más" → pantalla Eventos con el modal de
                            // detalle de este evento superpuesto.
                            onViewMore: () => onGoToEventos?.call(e),
                            // "Registrarse" → el formulario de registro.
                            onRegister: () => RegistroModal.mostrar(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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

  /// Alto de la cabecera en Figma. No cambia con la barra de estado: el fondo
  /// va a sangre por detrás de ella y solo se desplaza el contenido.
  static const double alto = 136;

  /// `y` del bloque de texto y de la campana en el diseño.
  static const double _topTexto = 26;
  static const double _topCampana = 30;

  @override
  Widget build(BuildContext context) {
    // Los dos bloques bajan lo mismo, así que conservan entre sí los 4 px de
    // diferencia que tienen en Figma.
    final double d = AreaSegura.desplazamiento(context, _topTexto);

    return Container(
      key: const Key('inicio-header'),
      width: double.infinity,
      height: alto,
      clipBehavior: Clip.antiAlias,
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
      child: SizedBox(
        width: double.infinity,
        height: alto,
        child: Stack(
          children: [
            Positioned(
              left: 26,
              top: _topTexto + d,
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
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Ingeniera Civil · Procalculo',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        color: const Color(0xFFD6EFFF),
                        fontSize: 14,
                        height: 1.14,
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              right: 26,
              top: _topCampana + d,
              child: _NotificationBell(
                onTap: onGoToNotifications,
              ),
            ),
          ],
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
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x4D000000),
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
    // Sin alto fijo: `IntrinsicHeight` mide la tarjeta más alta —la que tenga
    // el título más largo— y estira las demás para igualarlas.
    return SizedBox(
      width: 360,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < itemCount; i++) ...[
                if (i > 0) const SizedBox(width: 24),
                SizedBox(width: itemWidth, child: itemBuilder(context, i)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
