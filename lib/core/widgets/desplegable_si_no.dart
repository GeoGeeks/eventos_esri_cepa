import 'dart:math' as math;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';
import 'mensaje_error_campo.dart';
import 'separador_opciones.dart';

/// Desplegable **Sí / No** de las dos pantallas de «Calificación evento».
///
/// Estaba escrito a mano en el paso 1 y otra vez en el paso 2; se unificó aquí
/// al añadirle dos cosas que las dos pantallas necesitan por igual:
///
/// 1. **El separador entre «Sí» y «No»** — el mismo [SeparadorOpciones] de la
///    sección de Filtros (1 px `#EBEBEB`).
/// 2. **El mensaje de campo obligatorio**: con [error] no nulo, el borde del
///    campo pasa a `#D83020` y debajo sale el aviso.
class DesplegableSiNo extends StatefulWidget {
  const DesplegableSiNo({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.onChanged,
    this.obligatorio = true,
    this.error,
  });

  /// Texto sobre el campo. Si [obligatorio], se le añade el asterisco rojo.
  final String etiqueta;

  /// [si] o [no]; nulo mientras no se elija nada.
  final String? valor;

  final ValueChanged<String?> onChanged;

  final bool obligatorio;

  /// Mensaje bajo el campo. Nulo mientras no haya error.
  final String? error;

  static const String si = 'si';
  static const String no = 'no';

  /// Alto del campo cerrado, el de Figma.
  static const double altoCampo = 44;

  /// Alto de cada opción del menú desplegado.
  static const double altoOpcion = 48;

  /// Margen del menú a cada lado de la pantalla: 26 del contenido + 26.
  static const double margenPantalla = 52;

  @override
  State<DesplegableSiNo> createState() => _DesplegableSiNoState();
}

class _DesplegableSiNoState extends State<DesplegableSiNo> {
  /// Solo para saber hacia dónde apunta la flecha.
  bool _abierto = false;

  @override
  Widget build(BuildContext context) {
    final bool conError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: Fonts.regular,
              fontWeight: Fonts.wRegular,
              fontSize: Fonts.text0h,
              height: 20 / 16,
              color: AppColors.textTitle,
            ),
            children: [
              TextSpan(text: widget.etiqueta),
              if (widget.obligatorio)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.requiredField),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: DesplegableSiNo.altoCampo,
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: conError ? AppColors.requiredField : AppColors.textSubtle,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: widget.valor,
              isExpanded: true,
              // El aviso de cierre llega también cuando el menú se descarta
              // con la pantalla ya desmontada, así que hay que comprobarlo.
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
                    DesplegableSiNo.margenPantalla,
                decoration: const BoxDecoration(color: AppColors.white),
              ),
              // La línea es un ítem más del menú, así que su alto entra en el
              // reparto: 48 / 1 / 48. `customHeights` existe justo para esto.
              //
              // ⚠️ La lista **no puede ser `const`**: al desplegarse, el
              // paquete escribe en ella el alto real de cada ítem
              // (`itemHeights[index] = size.height`) y con una lista inmutable
              // revienta con «Cannot modify an unmodifiable list».
              menuItemStyleData: MenuItemStyleData(
                customHeights: <double>[
                  DesplegableSiNo.altoOpcion,
                  SeparadorOpciones.grosor,
                  DesplegableSiNo.altoOpcion,
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
              items: const [
                DropdownMenuItem(value: DesplegableSiNo.si, child: _Opcion('Sí')),
                // No se puede elegir: solo separa las dos opciones.
                DropdownMenuItem<String>(
                  enabled: false,
                  child: SeparadorOpciones(),
                ),
                DropdownMenuItem(value: DesplegableSiNo.no, child: _Opcion('No')),
              ],
              onChanged: widget.onChanged,
            ),
          ),
        ),
        if (conError) MensajeErrorCampo(texto: widget.error!),
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
