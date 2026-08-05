import 'package:flutter/material.dart';

import '../core/widgets/bottom_nav.dart';
import '../features/inicio/inicio.dart';
import '../features/eventos/data/proximos_eventos_data.dart';
import '../features/eventos/eventos_screen.dart';
import '../features/historial/presentation/screens/historial_screen.dart';
import '../features/reservas/reservas_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';
import '../features/profile/presentation/screens/e_card_screen.dart';
import '../features/post_evento/presentation/screens/post_evento_screen.dart';

class Menu extends StatefulWidget {
  final int initialIndex;

  const Menu({super.key, this.initialIndex = 0});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int currentIndex;

  // Controla sub-vistas especiales
  bool _showEcard = false;
  bool _showPostEvento = false;
  bool _showEventosFromInicio = false;

  /// Evento cuyo modal de detalle debe abrirse al entrar a Eventos desde el
  /// "Ver más" de una tarjeta de Inicio. Nulo si se llegó por "Ver todos".
  ProximoEvento? _eventoDetalle;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    setState(() {
      currentIndex = index;
      _showEventosFromInicio = false; // Reset al tocar cualquier ícono del menú
      _eventoDetalle = null;
      _showPostEvento = false; // Reset al tocar cualquier ícono del menú
      if (index == 4) {
        _showEcard = false;
      }
    });
  }

  Widget _buildPage(int index) {
    // Si está mostrando PostEvento, lo prioriza
    if (_showPostEvento) {
      return PostEventoScreen(
        onBack: () => setState(() => _showPostEvento = false),
      );
    }

    // Si viene desde "Ver todos" o desde el "Ver más" de una tarjeta de Inicio
    if (_showEventosFromInicio) {
      return EventosScreen(
        // La clave hace que Flutter reconstruya la pantalla al cambiar de
        // evento; si no, initState no vuelve a correr y el modal no se abre.
        key: ValueKey(_eventoDetalle?.id ?? 'todos'),
        eventoInicial: _eventoDetalle,
      );
    }

    switch (index) {
      case 0:
        return InicioApp(
          onGoToNotifications: () => _onNavTap(3),
          onGoToEventos: (evento) {
            setState(() {
              _showEventosFromInicio = true;
              _eventoDetalle = evento;
            });
          },
        );

      case 1:
        return HistorialScreen(
          onOpenPostEvento: () => setState(() => _showPostEvento = true),
        );

      case 2:
        return const ReservasScreen();

      case 3:
        return const NotificationsScreen();

      case 4:
        return _showEcard
            ? ECardScreen(onBack: () => setState(() => _showEcard = false))
            : ProfileMenuScreen(
                onOpenEcard: () => setState(() => _showEcard = true),
              );
        
      

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(currentIndex),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNav(
          // Si estamos mostrando Eventos desde Inicio o PostEvento, le enviamos -1 para desmarcar ítems,
          // o puedes pasarle currentIndex si deseas que el ícono permanezca seleccionado.
          currentIndex: (_showEventosFromInicio || _showPostEvento) ? -1 : currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
