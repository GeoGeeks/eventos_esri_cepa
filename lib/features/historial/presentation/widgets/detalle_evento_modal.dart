import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../data/eventos_data.dart';

class DetalleEventoModal extends StatelessWidget {
  final Evento evento;

  const DetalleEventoModal({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 358),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        evento.titulo,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                          color: Color(0xFF141414),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: AppColors.textTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Container
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _DetailRow(
                      iconAsset: 'assets/icons/date.svg',
                      fallbackIcon: Icons.calendar_month_outlined,
                      text: evento.fecha,
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      iconAsset: 'assets/icons/time.svg',
                      fallbackIcon: Icons.access_time_outlined,
                      text: evento.hora,
                    ),
                    const SizedBox(height: 8),
                    _DetailRow(
                      iconAsset: 'assets/icons/lugar.svg',
                      fallbackIcon: Icons.location_on_outlined,
                      text: evento.direccion,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Este evento es el espacio ideal para compartir '
                      'conocimientos, experiencias y soluciones que '
                      'están marcando la diferencia en la comunidad '
                      'académica y profesional.',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        height: 16 / 14,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                  ),
                ),
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Registro exitoso en ${evento.titulo}',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String iconAsset;
  final IconData fallbackIcon;
  final String text;

  const _DetailRow({
    required this.iconAsset,
    required this.fallbackIcon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(
            iconAsset,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.textSubtle,
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              fallbackIcon,
              size: 16,
              color: AppColors.textSubtle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: Fonts.regular,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
              color: AppColors.textTitle,
            ),
          ),
        ),
      ],
    );
  }
}
