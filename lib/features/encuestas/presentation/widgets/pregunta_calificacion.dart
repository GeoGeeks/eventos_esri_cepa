import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';
import '../../data/pregunta.dart';
import 'etiqueta_pregunta.dart';

/// 1 a 5 estrellas de una [Pregunta] `calificacion` - mismo control (32x32,
/// gap 8, ícono `favoritos`/`star_f`) que ya usaba `ValoracionPaso1Screen`
/// para "¿Qué le pareció?", generalizado a cualquier pregunta.
class PreguntaCalificacion extends StatelessWidget {
  const PreguntaCalificacion({
    super.key,
    required this.pregunta,
    required this.valor,
    required this.onChanged,
    this.soloLectura = false,
    this.error,
  });

  final Pregunta pregunta;

  /// 0 = sin calificar todavía.
  final int valor;
  final ValueChanged<int> onChanged;
  final bool soloLectura;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaPregunta(texto: pregunta.texto, obligatoria: pregunta.obligatoria),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            final llena = valor > i;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: soloLectura ? null : () => onChanged(i + 1),
                child: AppIcon(
                  llena ? SvgIcon.estrellaLlena : SvgIcon.favoritos,
                  width: 32,
                  height: 32,
                  color: llena ? AppColors.primary : AppColors.textSubtle,
                ),
              ),
            );
          }),
        ),
        if (error != null) MensajeErrorCampo(texto: error!),
      ],
    );
  }
}
