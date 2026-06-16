import 'package:flutter/material.dart';
import '../features/inicio/inicio.dart';
import '../core/widgets/bottom_nav.dart';
import '../features/reservas/reservas_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const InicioApp(),                        
      const Center(child: Text('Historial')),   
      const ReservasScreen(),                  
      const Center(child: Text('Alertas')),     
      const ProfileMenuScreen(),                
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}