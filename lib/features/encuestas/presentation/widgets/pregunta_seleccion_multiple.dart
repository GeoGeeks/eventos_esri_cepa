import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';
import '../../data/pregunta.dart';
import 'etiqueta_pregunta.dart';

/// Lista de checkboxes de una [Pregunta] `seleccion_multiple` - mismo
/// control (ícono `cuadro` 16x16, cuadro azul+check al marcar) que ya usaba
/// `ValoracionPaso1Screen` para "Seleccione los días en los que participó",
/// generalizado a las [Pregunta.opciones] reales en vez de los 3 días fijos.
class PreguntaSeleccionMultiple extends StatelessWidget {
  const PreguntaSeleccionMultiple({
    super.key,
    required this.pregunta,
    required this.seleccionadas,
    required this.onChanged,
    this.soloLectura = false,
    this.error,
  });

  final Pregunta pregunta;
  final Set<String> seleccionadas;
  final ValueChanged<Set<String>> onChanged;
  final bool soloLectura;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaPregunta(texto: pregunta.texto, obligatoria: pregunta.obligatoria),
        Column(
          children: [
            for (final opcion in pregunta.opciones)
              _fila(
                label: opcion.texto,
                value: seleccionadas.contains(opcion.id),
                onTap: soloLectura
                    ? null
                    : () {
                        final nuevas = Set<String>.from(seleccionadas);
                        if (nuevas.contains(opcion.id)) {
                          nuevas.remove(opcion.id);
                        } else {
                          nuevas.add(opcion.id);
                        }
                        onChanged(nuevas);
                      },
              ),
          ],
        ),
        if (error != null) MensajeErrorCampo(texto: error!),
      ],
    );
  }

  Widget _fila({
    required String label,
    required bool value,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      height: 32,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Center(
                child: value
                    ? Container(
                        width: 16,
                        height: 16,
                        color: AppColors.primary,
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: AppColors.white,
                        ),
                      )
                    : AppIcon(
                        SvgIcon.cuadro,
                        width: 16,
                        height: 16,
                        color: AppColors.textSubtle,
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontWeight: Fonts.wRegular,
                  fontSize: Fonts.text0h,
                  height: 20 / 16,
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
