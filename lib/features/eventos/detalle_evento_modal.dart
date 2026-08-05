import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../registro/presentation/registro_modal.dart';
import 'data/proximos_eventos_data.dart';

class DetalleEventoModal extends StatelessWidget {
  final ProximoEvento evento;

  const DetalleEventoModal({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 358,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER (height: 69px) ---
            Container(
              width: 358,
              // 69 del diseño como mínimo: si el título del evento necesita
              // más de un renglón, la cabecera crece en vez de recortarlo.
              constraints: const BoxConstraints(minHeight: 69),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        height: 32 / 26,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      // `close.svg` no existe en el proyecto; el ícono de cerrar
                      // es `x.svg` (8,041 × 8,020 dentro de una caja de 16).
                      child: Center(
                        child: SvgPicture.asset(
                          SvgIcon.x,
                          width: 8.041,
                          height: 8.020,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF6B6B6B),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- CONTENT CONTAINER ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DetailRow(
                    iconAsset: 'assets/icons/date.svg',
                    fallbackIcon: Icons.calendar_today_outlined,
                    text: evento.fecha,
                  ),
                  const SizedBox(height: 4),
                  _DetailRow(
                    iconAsset: 'assets/icons/time.svg',
                    fallbackIcon: Icons.access_time_outlined,
                    text: evento.hora,
                  ),
                  const SizedBox(height: 4),
                  _DetailRow(
                    iconAsset: 'assets/icons/lugar.svg',
                    fallbackIcon: Icons.location_on_outlined,
                    text: evento.direccion,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    evento.descripcion,
                    style: const TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 16 / 14,
                      color: Color(0xFF141414),
                    ),
                  ),
                ],
              ),
            ),

            // --- FOOTER ---
            Container(
              width: 358,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  // Cierra el detalle y abre el formulario de registro.
                  onPressed: () {
                    Navigator.of(context).pop();
                    RegistroModal.mostrar(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AC2),
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
                      fontWeight: FontWeight.w400,
                      height: 20 / 16,
                      color: Colors.white,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: SvgPicture.asset(
            iconAsset,
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              Color(0xFF007AC2),
              BlendMode.srcIn,
            ),
            placeholderBuilder: (context) => Icon(
              fallbackIcon,
              size: 16,
              color: const Color(0xFF007AC2),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 20 / 16,
              color: Color(0xFF141414),
            ),
          ),
        ),
      ],
    );
  }
}
