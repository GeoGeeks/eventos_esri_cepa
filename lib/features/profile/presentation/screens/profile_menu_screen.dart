import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section_title.dart';
import 'e_card_screen.dart';
import '../../../../core/constants/images.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header azul ──
            Container(
  width: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(Images.headerInicio),
      fit: BoxFit.cover,
    ),
  ),
  padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
  child: Row(
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          'ML',
          style: TextStyle(
            fontFamily: Fonts.light,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(width: 16),
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'María López',
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ingeniera Civil · Procalculo',
            style: TextStyle(
              fontFamily: Fonts.light,
              fontSize: 13,
              fontWeight: FontWeight.w400,                    
              color: Colors.white,
            ),
          ),
        ],
      ),
    ],
  ),
),

            const SizedBox(height: 8),

            const ProfileSectionTitle(title: 'Perfil'),

            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Configuración',
              onTap: () {},
            ),

            ProfileMenuItem(
              icon: Icons.badge_outlined,
              title: 'E-card',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ECardScreen(),
                  ),
                );
              },
            ),

            ProfileMenuItem(
              icon: Icons.notifications_none,
              title: 'Notificaciones',
              onTap: () {},
            ),

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