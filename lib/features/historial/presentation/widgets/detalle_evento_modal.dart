import 'package:flutter/material.dart';

import '../../data/eventos_data.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class DetalleEventoModal extends StatelessWidget {
  final Evento evento;

  const DetalleEventoModal({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 40,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close,
                  color: AppColors.textTitle,
                ),
              ),
            ),

            Text(
              evento.titulo,
              style: const TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textTitle,
              ),
            ),

            const SizedBox(height: 16),

            _DetailRow(
              icon: Icons.calendar_month_outlined,
              text: evento.fecha,
            ),

            const SizedBox(height: 10),

            _DetailRow(
              icon: Icons.access_time_outlined,
              text: evento.hora,
            ),

            const SizedBox(height: 10),

            _DetailRow(
              icon: Icons.location_on_outlined,
              text: evento.direccion,
            ),

            const SizedBox(height: 16),

            const Text(
              'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
              style: TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSubtle,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
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
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontFamily: Fonts.avenir,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: AppColors.textSubtle,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textTitle,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}