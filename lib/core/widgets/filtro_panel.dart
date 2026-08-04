import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import 'casilla_verificacion.dart';

class FiltroPanel extends StatelessWidget {
  final String titulo;
  final List<String> opciones;
  final Set<String> seleccionadas;
  final ValueChanged<String> onOpcion;

  const FiltroPanel({
    super.key,
    required this.titulo,
    required this.opciones,
    required this.seleccionadas,
    required this.onOpcion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Text(
            titulo,
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wMedium,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.modalSubtitle,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.lightGray,
        ),
        const SizedBox(height: 12.5),
        for (var i = 0; i < opciones.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _Opcion(
            texto: opciones[i],
            marcada: seleccionadas.contains(opciones[i]),
            onTap: () => onOpcion(opciones[i]),
          ),
        ],
      ],
    );
  }
}

class _Opcion extends StatelessWidget {
  final String texto;
  final bool marcada;
  final VoidCallback onTap;

  const _Opcion({
    required this.texto,
    required this.marcada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 20,
        child: Row(
          children: [
            const SizedBox(width: 14),
            CasillaVerificacion(marcada: marcada, lado: 13),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                texto,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: Fonts.textSm,
                  fontWeight: Fonts.wRegular,
                  height: 20 / 14,
                  letterSpacing: 0,
                  color: AppColors.textTitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
