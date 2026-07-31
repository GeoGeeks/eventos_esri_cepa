import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../../login/login_screen.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section_title.dart';

class ProfileMenuScreen extends StatelessWidget {
  final VoidCallback onOpenEcard;

  const ProfileMenuScreen({super.key, required this.onOpenEcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER (Rectángulo 12) ──
            Container(
              width: double.infinity,
              height: 110,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.headerInicio),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              padding: const EdgeInsets.only(left: 26, top: 30, right: 26),
              alignment: Alignment.topLeft,

              // ── Fotograma 4 ──
              child: SizedBox(
                height: 68,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar (44x44, #D6EFFF)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD6EFFF),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'ML',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: Fonts.bold,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A4A4A),
                            height: 1.25,
                          ),
                        ),
                      ),

                      const SizedBox(width: 17), // gap: 17px
                      // Fotograma 1 (Texto) - Con Expanded para no truncar a 114px
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'María López',
                              style: TextStyle(
                                fontFamily: Fonts.bold,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                                height: 1.20,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              'Ingeniera Civil',
                              style: TextStyle(
                                fontFamily: Fonts.light,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFFFFFFF),
                                height: 1.25,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── CONTENIDO INTERIOR DE 362px ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 20, bottom: 24),
                child: Center(
                  child: SizedBox(
                    width: 362,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Perfil ──
                        const ProfileSectionTitle(title: 'Perfil'),
                        ProfileMenuItem(
                          icon: 'assets/icons/configuracion.svg',
                          title: 'Configuración',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/e-card.svg',
                          title: 'E-card',
                          onTap: onOpenEcard,
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/campana.svg',
                          title: 'Notificaciones',
                          onTap: () {},
                          showBorder: false,
                        ),

                        const SizedBox(height: 20),

                        // ── Eventos ──
                        const ProfileSectionTitle(title: 'Eventos'),
                        ProfileMenuItem(
                          icon: 'assets/icons/reservas.svg',
                          title: 'Reservas',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/favoritos.svg',
                          title: 'Mis favoritos',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/encuestas.svg',
                          title: 'Mis encuestas',
                          onTap: () {},
                          showBorder: false,
                        ),

                        const SizedBox(height: 20),

                        // ── Soporte ──
                        const ProfileSectionTitle(title: 'Soporte'),
                        ProfileMenuItem(
                          icon: 'assets/icons/contactenos.svg',
                          title: 'Contáctenos',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/whatsapp.svg',
                          title: 'Chat por WhatsApp',
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: 'assets/icons/preguntas.svg',
                          title: 'Preguntas frecuentes',
                          onTap: () {},
                          showBorder: false,
                        ),

                        const SizedBox(height: 24),

                        LogoutButton(
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Image.asset(
                            Images.profile1,
                            width: 108,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
