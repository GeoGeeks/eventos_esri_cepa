import 'package:flutter/material.dart';

import '../core/widgets/bottom_nav.dart';
import '../features/inicio/inicio.dart';
import '../features/eventos/eventos_screen.dart';
import '../features/historial/presentation/screens/historial_screen.dart';
import '../features/reservas/reservas_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';
import '../features/profile/presentation/screens/e_card_screen.dart';

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
  bool _showEventosFromInicio = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onNavTap(int index) {
    setState(() {
      currentIndex = index;
      _showEventosFromInicio = false; // Reset al tocar cualquier ícono del menú
      if (index == 4) {
        _showEcard = false;
      }
    });
  }

  Widget _buildPage(int index) {
    // Si viene desde "Ver todos" en Inicio
    if (_showEventosFromInicio) {
      return const EventosScreen();
    }

    switch (index) {
      case 0:
        return InicioApp(
          onGoToNotifications: () => _onNavTap(3),
          onGoToEventos: () {
            setState(() {
              _showEventosFromInicio = true;
            });
          },
        );

      case 1:
        return const HistorialScreen(); // O tu pantalla del tab 1

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
          // Si estamos mostrando Eventos desde Inicio, le enviamos -1 para desmarcar ítems,
          // o puedes pasarle currentIndex (0) si deseas que 'Inicio' permanezca seleccionado.
          currentIndex: _showEventosFromInicio ? -1 : currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
