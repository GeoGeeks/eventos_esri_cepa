import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';
import '../../../../core/widgets/separador_opciones.dart';
import '../../data/pregunta.dart';
import 'etiqueta_pregunta.dart';

/// Desplegable de una [Pregunta] `seleccion` (una sola opción) - misma
/// estructura visual que `DesplegableSiNo` (campo 44 alto, borde
/// `#949494`, menú con [SeparadorOpciones] entre ítems), generalizada a
/// [Pregunta.opciones] en vez de las 2 opciones fijas Sí/No.
class PreguntaSeleccion extends StatefulWidget {
  const PreguntaSeleccion({
    super.key,
    required this.pregunta,
    required this.valor,
    required this.onChanged,
    this.soloLectura = false,
    this.error,
  });

  final Pregunta pregunta;

  /// `id` de la [OpcionPregunta] elegida, o `null` mientras no se elige nada.
  final String? valor;
  final ValueChanged<String?> onChanged;
  final bool soloLectura;
  final String? error;

  /// Alto del campo cerrado y de cada opción del menú - iguales a
  /// `DesplegableSiNo`.
  static const double altoCampo = 44;
  static const double altoOpcion = 48;
  static const double margenPantalla = 52;

  @override
  State<PreguntaSeleccion> createState() => _PreguntaSeleccionState();
}

class _PreguntaSeleccionState extends State<PreguntaSeleccion> {
  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    final opciones = widget.pregunta.opciones;
    final texto = widget.valor == null
        ? null
        : opciones.firstWhere((o) => o.id == widget.valor).texto;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EtiquetaPregunta(
          texto: widget.pregunta.texto,
          obligatoria: widget.pregunta.obligatoria,
        ),
        const SizedBox(height: 8),
        if (widget.soloLectura)
          Container(
            height: PreguntaSeleccion.altoCampo,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.textSubtle, width: 1),
            ),
            child: Text(
              texto ?? '',
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontSize: Fonts.text0h,
                height: 20 / 16,
                color: AppColors.textTitle,
              ),
            ),
          )
        else
          Container(
            height: PreguntaSeleccion.altoCampo,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: widget.error != null
                    ? AppColors.requiredField
                    : AppColors.textSubtle,
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                value: widget.valor,
                isExpanded: true,
                onMenuStateChange: (abierto) {
                  if (!mounted) return;
                  setState(() => _abierto = abierto);
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(left: 16, right: 10),
                ),
                iconStyleData: IconStyleData(
                  icon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: Transform.rotate(
                        angle: _abierto ? math.pi / 2 : -math.pi / 2,
                        child: const AppIcon(
                          SvgIcon.back,
                          width: 8.414,
                          height: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  offset: const Offset(0, -2),
                  width: MediaQuery.of(context).size.width -
                      PreguntaSeleccion.margenPantalla,
                  decoration: const BoxDecoration(color: AppColors.white),
                ),
                // Mismo motivo que `DesplegableSiNo`: la lista no puede ser
                // `const` porque el paquete escribe en ella el alto real de
                // cada ítem al desplegarse.
                menuItemStyleData: MenuItemStyleData(
                  customHeights: [
                    for (var i = 0; i < opciones.length; i++) ...[
                      if (i > 0) SeparadorOpciones.grosor,
                      PreguntaSeleccion.altoOpcion,
                    ],
                  ],
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                hint: const Text(
                  'Seleccione',
                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontWeight: Fonts.wLight,
                    fontSize: Fonts.text0h,
                    height: 20 / 16,
                    color: AppColors.textMuted,
                  ),
                ),
                items: [
                  for (var i = 0; i < opciones.length; i++) ...[
                    if (i > 0)
                      const DropdownMenuItem<String>(
                        enabled: false,
                        child: SeparadorOpciones(),
                      ),
                    DropdownMenuItem(
                      value: opciones[i].id,
                      child: _Opcion(opciones[i].texto),
                    ),
                  ],
                ],
                onChanged: widget.onChanged,
              ),
            ),
          ),
        if (widget.error != null) MensajeErrorCampo(texto: widget.error!),
      ],
    );
  }
}

class _Opcion extends StatelessWidget {
  const _Opcion(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontFamily: Fonts.regular,
        fontWeight: Fonts.wRegular,
        fontSize: Fonts.text0h,
        height: 20 / 16,
        letterSpacing: 0,
        color: AppColors.textTitle,
      ),
    );
  }
}
