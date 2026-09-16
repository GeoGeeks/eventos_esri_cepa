import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/event_card.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../credencial/presentation/credencial_modal.dart';
import '../eventos/data/evento.dart';
import '../eventos/data/eventos_store.dart';
import '../eventos/detalle_evento_modal.dart';
import '../invitados/invitados.dart';
import '../login/presentation/bloc/auth_cubit.dart';
import '../login/presentation/bloc/auth_state.dart';
import '../registro/presentation/registro_modal.dart';

class InicioApp extends StatelessWidget {
  final VoidCallback? onGoToNotifications;

  /// Abre la pantalla Eventos: es el chip "Ver todos". Las tarjetas ya no
  /// navegan, abren sus modales sobre Inicio.
  final VoidCallback? onGoToEventos;

  const InicioApp({
    super.key,
    this.onGoToNotifications,
    this.onGoToEventos,
  });

  /// Misma «ventana evento» que la pantalla Eventos, superpuesta sobre Inicio.
  /// El scrim del diseño es #000000 al 50 % — modalOverlay es 0x80.
  void _abrirModalDetalle(BuildContext context, Evento evento) {
    showDialog(
      context: context,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => DetalleEventoModal(evento: evento),
    );
  }

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
                      _SeccionEventos(
                        onVerTodos: onGoToEventos,
                        onAbrirDetalle: (evento) =>
                            _abrirModalDetalle(context, evento),
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

/// "Eventos reservados" (carrusel) + "Próximos eventos" (lista) - las dos
/// secciones reales de `EventosCargados`, separadas de `InicioApp` para
/// reaccionar solas a `EventosStore.estado` sin reconstruir la cabecera.
class _SeccionEventos extends StatelessWidget {
  final VoidCallback? onVerTodos;
  final void Function(Evento) onAbrirDetalle;

  const _SeccionEventos({
    required this.onVerTodos,
    required this.onAbrirDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EventosEstado>(
      valueListenable: EventosStore.estado,
      builder: (context, estado, _) {
        return switch (estado) {
          EventosSinCargar() || EventosCargando() => const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          EventosError(:final mensaje) => Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Column(
                children: [
                  Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => EventosStore.cargar(forzar: true),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),
          EventosCargados(:final reservados, :final proximos) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reservados.isNotEmpty) ...[
                const _SectionTitle(title: 'Eventos reservados'),
                const SizedBox(height: 12),
                _HorizontalCarousel(
                  itemCount: reservados.length,
                  itemWidth: 237,
                  itemBuilder: (context, i) {
                    final e = reservados[i];
                    return EventCard(
                      title: e.nombre,
                      date: e.fechaYHoraFormateada,
                      location: e.lugar ?? '',
                      image: e.imagenParaCarta,
                      // "Ver más" de un evento reservado → Invitados.
                      onViewMore: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InvitadosScreen(eventoReal: e),
                          ),
                        );
                      },
                      // "Mi credencial" → el modal de la credencial.
                      onCredential: () => CredencialModal.mostrar(context),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
              _SectionTitle(
                title: 'Próximos eventos',
                action: _SeeAllChip(onTap: () => onVerTodos?.call()),
              ),
              const SizedBox(height: 12),
              if (proximos.isEmpty)
                const Text(
                  'No hay más eventos por ahora.',
                  style: TextStyle(fontFamily: Fonts.regular, color: Colors.grey),
                )
              else
                ...proximos.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: UpcomingEventCard(
                      title: e.nombre,
                      date: e.fechaYHoraFormateada,
                      location: e.lugar ?? '',
                      image: e.imagenParaCarta,
                      mode: e.presencial ? 'Presencial' : 'Virtual',
                      // "Ver más" → el modal de detalle del evento, sin
                      // salir de Inicio.
                      onViewMore: () => onAbrirDetalle(e),
                      // "Registrarse" → el formulario de registro.
                      onRegister: () => RegistroModal.mostrar(context),
                    ),
                  ),
                ),
            ],
          ),
        };
      },
    );
  }
}

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

    // Menu (y por lo tanto Inicio) solo se muestra tras AuthAutenticado, ver
    // main.dart (_Arranque) - el perfil siempre debería estar disponible
    // acá, pero se deja el fallback por si acaso en vez de asumirlo.
    final estadoAuth = context.watch<AuthCubit>().state;
    final perfil = estadoAuth is AuthAutenticado ? estadoAuth.perfil : null;
    final nombre = perfil?.nombreCompleto ?? '';
    final subtitulo = perfil?.cargoYOrganizacion;
    final saludo = perfil?.saludo ?? 'Bienvenido';

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
              // 76 = 26 (margen de la campana) + 40 (su ancho) + 10 (aire) -
              // a diferencia del mock "María López", un nombre real puede
              // no caber; sin este right: el texto se sale de la pantalla
              // por debajo/detrás de la campana en vez de truncarse.
              right: 76,
              top: _topTexto + d,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      saludo,
                      style: const TextStyle(
                        fontFamily: Fonts.medium,
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // FittedBox en vez de maxLines+ellipsis: a diferencia del
                    // mock "María López", un nombre real puede no caber a
                    // 32px — con ellipsis se cortaba a mitad de palabra
                    // (p.ej. "VALENTINA PIRAV..."); así se reduce el tamaño
                    // hasta que quepa completo en una línea, sin agrandar
                    // nombres cortos (scaleDown nunca escala hacia arriba).
                    SizedBox(
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          nombre,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: Fonts.bold,
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ),
                    if (subtitulo != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          color: const Color(0xFFD6EFFF),
                          fontSize: 14,
                          height: 1.14,
                        ),
                      ),
                    ],
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
                _CarouselItem(
                  width: itemWidth,
                  child: itemBuilder(context, i),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Envuelve cada tarjeta del carrusel: si queda parcialmente cortada (como la
/// que asoma a la derecha), tocarla la desplaza al centro de la pantalla —
/// sin navegar a ningún lado, eso lo siguen haciendo solo sus propios
/// botones («Ver más»/«Mi credencial»), que ganan el toque cuando caen
/// dentro de ellos.
class _CarouselItem extends StatelessWidget {
  final double width;
  final Widget child;

  const _CarouselItem({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
      child: SizedBox(width: width, child: child),
    );
  }
}
