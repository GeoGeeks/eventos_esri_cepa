import 'package:flutter/material.dart';

import '../core/widgets/bottom_nav.dart';
import '../features/inicio/inicio.dart';
import '../features/eventos/eventos_screen.dart';
import '../features/historial/presentation/screens/historial_screen.dart';
import '../features/notificaciones/data/push_notificaciones_service.dart';
import '../features/reservas/reservas_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/profile/presentation/screens/profile_menu_screen.dart';
import '../features/profile/presentation/screens/e_card_screen.dart';
import '../features/post_evento/presentation/screens/post_evento_screen.dart';

class Menu extends StatefulWidget {
  final int initialIndex;

  /// Seam para tests (inyectar un doble sin tocar Firebase real) - mismo
  /// patrón que `EsriEventosApp({AuthCubit? authCubit})`. En la app real se
  /// deja `null` y se crea uno de verdad.
  final PushNotificacionesService? pushNotificaciones;

  const Menu({
    super.key,
    this.initialIndex = 0,
    this.pushNotificaciones,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int currentIndex;

  // Controla sub-vistas especiales
  bool _showEcard = false;
  bool _showPostEvento = false;
  bool _showEventosFromInicio = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;

    // `Menu` solo se construye con sesión ya autenticada (ver `_Arranque`
    // en main.dart) - es el punto natural para pedir permiso de push y
    // registrar el device token, sin importar si la sesión vino de un login
    // recién hecho o de una restaurada al abrir la app.
    //
    // Envuelto en try/catch a propósito: el push es "mejor esfuerzo" - si
    // Firebase no llegó a inicializarse (falta Google Play Services en el
    // dispositivo, o el entorno de test de este widget, que nunca corre
    // `main()`/`Firebase.initializeApp()`), la app debe seguir funcionando
    // igual, solo sin notificaciones, no tumbar la pantalla principal.
    _inicializarPush();
  }

  Future<void> _inicializarPush() async {
    try {
      final push = widget.pushNotificaciones ?? PushNotificacionesService();
      await push.registrarParaSesionActual();
      push.configurarListeners();
    } catch (_) {
      // Ver comentario de `initState`.
    }
  }

  void _onNavTap(int index) {
    setState(() {
      currentIndex = index;
      _showEventosFromInicio = false; // Reset al tocar cualquier ícono del menú
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

    // Si viene desde el "Ver todos" de Inicio
    if (_showEventosFromInicio) {
      return const EventosScreen();
    }

    switch (index) {
      case 0:
        return InicioApp(
          onGoToNotifications: () => _onNavTap(3),
          onGoToEventos: () {
            setState(() => _showEventosFromInicio = true);
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
