import 'package:flutter/material.dart';

import '../core/widgets/bottom_nav.dart';

import '../features/inicio/inicio.dart';
import '../features/historial/presentation/screens/historial_screen.dart';
import '../features/reservas/reservas_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentIndex = 0;

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
        return const ProfileMenuScreen();

      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(currentIndex),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}