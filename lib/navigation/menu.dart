import 'package:flutter/material.dart';

import '../core/widgets/bottom_nav.dart';

import '../features/inicio/inicio.dart';
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
  late int currentIndex = widget.initialIndex;

  // Sub-vista dentro del tab "Perfil" (index 4).
  bool _showEcard = false;

  void _onNavTap(int index) {
    setState(() {
      currentIndex = index;
      if (index == 4) {
        // Al tocar el ícono "Perfil" siempre volvemos al menú raíz.
        _showEcard = false;
      }
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const InicioApp();

      case 1:
        return const HistorialScreen();

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
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(currentIndex),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNav
        (currentIndex: currentIndex,
         onTap: _onNavTap
         ),
      ),
    );
  }
}
