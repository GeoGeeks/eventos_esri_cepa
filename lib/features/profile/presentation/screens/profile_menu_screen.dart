import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section_title.dart';

class ProfileMenuScreen extends StatelessWidget {
  final VoidCallback onOpenEcard;

  const ProfileMenuScreen({super.key, required this.onOpenEcard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header azul (Diseño Rectangle 12) ──
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.headerInicio),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(26, 52, 26, 30),
              child: Row(
                children: [
                  // Avatar con iniciales
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD6EFFF), // Color según diseño
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'ML',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 16,
                        fontWeight: FontWeight.w700, // Avenir Bold
                        color: Color(0xFF4A4A4A),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17),
                  // Nombre e Información Profesional
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'María López',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 20,
                            fontWeight: FontWeight.w700, // Avenir Bold
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Ingeniera Civil',
                          style: TextStyle(
                            fontFamily: Fonts.light,
                            fontSize: 16,
                            fontWeight: FontWeight.w300, // Avenir Light
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Sección: Perfil ──
            const ProfileSectionTitle(title: 'Perfil'),

            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Configuración',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.badge_outlined,
              title: 'E-card',
              onTap: onOpenEcard,
            ),

            ProfileMenuItem(
              icon: Icons.notifications_none,
              title: 'Notificaciones',
              onTap: () {},
            ),

            // ── Sección: Eventos ──
            const ProfileSectionTitle(title: 'Eventos'),

            ProfileMenuItem(
              icon: Icons.calendar_month_outlined,
              title: 'Reservas',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.star_border,
              title: 'Mis favoritos',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.article_outlined,
              title: 'Mis Encuestas',
              onTap: () {},
            ),

            // ── Sección: Soporte ──
            const ProfileSectionTitle(title: 'Soporte'),

            ProfileMenuItem(
              icon: Icons.mail_outline,
              title: 'Contáctanos',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.chat_outlined,
              title: 'Chat por WhatsApp',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Preguntas frecuentes',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            LogoutButton(onPressed: () {}),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.language,
                  size: 14,
                  color: AppColors.textSubtle,
                ),
                const SizedBox(width: 4),
                Text(
                  'esri Colombia',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
