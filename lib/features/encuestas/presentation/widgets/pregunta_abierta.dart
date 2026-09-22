import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';
import '../../data/pregunta.dart';
import 'etiqueta_pregunta.dart';

/// Campo de texto libre de una [Pregunta] `abierta` - mismo control que ya
/// usaban `ValoracionPaso1Screen`/`ValoracionPaso2Screen` (textarea 360x132
/// con el "drag-handle" decorativo en la esquina), generalizado a cualquier
/// [Pregunta] en vez de los comentarios fijos de esas dos pantallas.
class PreguntaAbierta extends StatelessWidget {
  const PreguntaAbierta({
    super.key,
    required this.pregunta,
    required this.controller,
    this.soloLectura = false,
    this.error,
  });

  final Pregunta pregunta;
  final TextEditingController controller;

  /// "Ver respuestas": el campo se ve, pero no se puede editar.
  final bool soloLectura;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaPregunta(texto: pregunta.texto, obligatoria: pregunta.obligatoria),
        const SizedBox(height: 8),
        Container(
          height: 132,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: error != null ? AppColors.requiredField : AppColors.textSubtle,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextField(
                  controller: controller,
                  readOnly: soloLectura,
                  maxLines: null,
                  expands: true,
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.text0h,
                    color: AppColors.textTitle,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Escriba su comentario aquí...',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.light,
                      fontWeight: Fonts.wLight,
                      fontSize: Fonts.text0h,
                      height: 20 / 16,
                      color: AppColors.textMuted,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (!soloLectura)
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: AppIcon(
                    SvgIcon.mensaje,
                    width: 9,
                    height: 9,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        if (error != null) MensajeErrorCampo(texto: error!),
      ],
    );
  }
}
