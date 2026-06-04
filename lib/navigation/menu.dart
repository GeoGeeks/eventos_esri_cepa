import 'package:flutter/material.dart';
import '../features/inicio/inicio.dart';
import '../core/widgets/bottom_nav.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const InicioApp(),
    const Center(child: Text('Historial')),
    const Center(child: Text('Reservas')),
    const Center(child: Text('Alertas')),
    const ProfileMenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}