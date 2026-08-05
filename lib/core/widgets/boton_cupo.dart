import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import '../../features/laboratorios/data/laboratorio_data.dart';
import 'app_icons.dart';

/// Botón de cupo de la tarjeta de Laboratorios — `laboratorios_card.svg`.
///
/// Tiene los tres estados de [EstadoCupo]:
///
/// | Estado | Aspecto |
/// |---|---|
/// | `disponible` | relleno `#007AC2`, «+ Reservar cupo» en blanco |
/// | `reservado` | borde `#D83020`, «Cancelar reserva» en rojo, sin «+» |
/// | `agotado` | borde y texto `#D4D4D4`, «+ Reservar cupos», sin acción |
class BotonCupo extends StatelessWidget {
  final EstadoCupo estado;
  final VoidCallback? onReservar;
  final VoidCallback? onCancelar;

  const BotonCupo({
    super.key,
    required this.estado,
    this.onReservar,
    this.onCancelar,
  });

  static const double alto = 32;

  @override
  Widget build(BuildContext context) {
    final bool reservado = estado == EstadoCupo.reservado;
    final bool agotado = estado == EstadoCupo.agotado;

    final Color color = agotado
        ? AppColors.deshabilitado
        : reservado
            ? AppColors.requiredField
            : AppColors.primary;
    final Color fondo = estado == EstadoCupo.disponible
        ? AppColors.primary
        : AppColors.white;
    final Color colorTexto =
        estado == EstadoCupo.disponible ? AppColors.white : color;

    final String texto = reservado
        ? 'Cancelar reserva'
        : agotado
            ? 'Reservar cupos'
            : 'Reservar cupo';

    return GestureDetector(
      key: const Key('boton-cupo'),
      onTap: agotado ? null : (reservado ? onCancelar : onReservar),
      child: Container(
        height: alto,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fondo,
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // El «+» solo acompaña a los dos estados de reserva.
            if (!reservado) ...[
              AppIcon(SvgIcon.mas, width: 16, height: 16, color: colorTexto),
              const SizedBox(width: 8),
            ],
            Text(
              texto,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: Fonts.textSm,
                fontWeight: Fonts.wRegular,
                height: 16 / 14,
                letterSpacing: 0,
                color: colorTexto,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
