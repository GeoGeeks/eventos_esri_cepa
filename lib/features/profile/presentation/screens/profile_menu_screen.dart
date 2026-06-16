import 'package:flutter/material.dart';
import '../../../../core/constants/images.dart';
import '../widgets/logout_button.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section_title.dart';

class ProfileMenuScreen extends StatelessWidget {
  const ProfileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ProfileSectionTitle(
            title: 'Perfil',
          ),

          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'Configuración',
            onTap: () {},
          ),

          ProfileMenuItem(
            icon: Icons.badge_outlined,
            title: 'E-card',
            onTap: () {},
          ),

          ProfileMenuItem(
            icon: Icons.notifications_none,
            title: 'Notificaciones',
            onTap: () {},
          ),

          const ProfileSectionTitle(
            title: 'Eventos',
          ),

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

          const ProfileSectionTitle(
            title: 'Soporte',
          ),

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

          const SizedBox(height: 20),

          LogoutButton(
            onPressed: () {},
          ),

          const SizedBox(height: 20),

          Image.asset(
            Images.profile1,
            height: 24,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}