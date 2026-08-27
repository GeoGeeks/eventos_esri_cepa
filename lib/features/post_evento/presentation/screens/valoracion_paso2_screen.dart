import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Constantes globales de tu arquitectura
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/desplegable_si_no.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';

import '../../data/valoracion_store.dart';
import '../widgets/politica_privacidad_modal.dart';
import '../widgets/valoracion_success_dialog.dart';

class ValoracionPaso2Screen extends StatefulWidget {
  const ValoracionPaso2Screen({super.key});

  @override
  State<ValoracionPaso2Screen> createState() => _ValoracionPaso2ScreenState();
}

class _ValoracionPaso2ScreenState extends State<ValoracionPaso2Screen> {
  String? deseaContacto;
  String? volveria1;
  String? laboratorio1;
  String? laboratorio2;
  String? volveria2;

  bool dia1 = false;
  bool dia2 = false;
  bool dia3 = false;

  bool acepta1 = false;
  bool acepta2 = false;

  /// Igual que en el paso 1: los errores no salen hasta pulsar «Enviar».
  bool _mostrarErrores = false;

  // ── Campos obligatorios (los marcados con * en el diseño) ──
  bool get _faltaDias => !dia1 && !dia2 && !dia3;

  bool get _formularioCompleto =>
      deseaContacto != null &&
      volveria1 != null &&
      laboratorio1 != null &&
      laboratorio2 != null &&
      volveria2 != null &&
      !_faltaDias;

  /// Texto del error de un campo, o nulo si no hay que mostrarlo todavía.
  String? _error(bool falta) =>
      _mostrarErrores && falta ? MensajeErrorCampo.obligatorio : null;

  void _enviar() {
    setState(() => _mostrarErrores = true);

    // Sin los obligatorios no se envía la encuesta.
    if (!_formularioCompleto) return;

    // A partir de aquí el evento queda valorado: en Post-evento se apaga
    // «Valorar evento» y se enciende «Certificado».
    ValoracionStore.marcarValorado();
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => const ValoracionSuccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // ✅ agregado
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BOTÓN ATRÁS ("Boton-chatbot": circle 36x36, azul #007AC2)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007AC2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const AppIcon(
                    SvgIcon.back,
                    width: 8.414,
                    height: 14,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// TÍTULO / CABECERA
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Queremos saber su opinión',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontWeight: Fonts.wRegular,
                        fontSize: Fonts.text0h,
                        height: 20 / 16,
                        color: Color(0xFF4A4A4A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CUE 2026',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontWeight: Fonts.wMedium,
                        fontSize: Fonts.text3h,
                        height: 32 / 26,
                        color: Color(0xFF141414),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// STEP-BARS (360x2, gap 12) — ambas barras completas (azul)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF007AC2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: const Color(0xFF007AC2),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// Desea ser contactado
              DesplegableSiNo(
                etiqueta: 'Desea ser contactado',
                valor: deseaContacto,
                error: _error(deseaContacto == null),
                onChanged: (v) => setState(() => deseaContacto = v),
              ),

              const SizedBox(height: 12),

              /// Volvería a participar (1)
              DesplegableSiNo(
                etiqueta: 'Volvería a participar',
                valor: volveria1,
                error: _error(volveria1 == null),
                onChanged: (v) => setState(() => volveria1 = v),
              ),

              const SizedBox(height: 12),

              /// Participó en los Laboratorios de entrenamiento (1)
              DesplegableSiNo(
                etiqueta: 'Participó en los Laboratorios de entrenamiento',
                valor: laboratorio1,
                error: _error(laboratorio1 == null),
                onChanged: (v) => setState(() => laboratorio1 = v),
              ),

              const SizedBox(height: 12),

              /// Participó en los Laboratorios de entrenamiento (2)
              DesplegableSiNo(
                etiqueta: 'Participó en los Laboratorios de entrenamiento',
                valor: laboratorio2,
                error: _error(laboratorio2 == null),
                onChanged: (v) => setState(() => laboratorio2 = v),
              ),

              const SizedBox(height: 12),

              /// SELECCIONE LOS DÍAS EN LOS QUE PARTICIPÓ
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontWeight: Fonts.wRegular,
                    fontSize: Fonts.text0h,
                    height: 20 / 16,
                    color: Color(0xFF141414),
                  ),
                  children: [
                    TextSpan(
                      text: 'Seleccione los días en los que participó',
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFD83020)),
                    ),
                  ],
                ),
              ),

              /// LISTA (checkboxes 16x16, icono: cuadro)
              Column(
                children: [
                  _buildCheckboxTile(
                    label: 'Día 1',
                    value: dia1,
                    onChanged: (v) => setState(() => dia1 = v),
                  ),
                  _buildCheckboxTile(
                    label: 'Día 2',
                    value: dia2,
                    onChanged: (v) => setState(() => dia2 = v),
                  ),
                  _buildCheckboxTile(
                    label: 'Día 3',
                    value: dia3,
                    onChanged: (v) => setState(() => dia3 = v),
                  ),
                ],
              ),

              if (_error(_faltaDias) != null)
                MensajeErrorCampo(texto: _error(_faltaDias)!),

              const SizedBox(height: 12),

              /// Volvería a participar (2)
              DesplegableSiNo(
                etiqueta: 'Volvería a participar',
                valor: volveria2,
                error: _error(volveria2 == null),
                onChanged: (v) => setState(() => volveria2 = v),
              ),

              const SizedBox(height: 12),

              /// CHECKBOX 1: Autorizo... (14x14, con enlace Términos y Condiciones)
              _buildTermsCheckbox(
                value: acepta1,
                onChanged: (v) => setState(() => acepta1 = v),
                showLink: true,
              ),

              /// CHECKBOX 2: Autorizo... (14x14, sin gap-top adicional)
              _buildTermsCheckbox(
                value: acepta2,
                onChanged: (v) => setState(() => acepta2 = v),
                showLink: false,
              ),

              const SizedBox(height: 28),

              /// BOTÓN CONTINUAR (360x44, azul #007AC2, texto #F7F7F7)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AC2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _enviar,
                  child: const Text(
                    'Enviar',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontWeight: Fonts.wRegular,
                      fontSize: Fonts.text0h,
                      height: 20 / 16,
                      color: Color(0xFFF7F7F7),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// Checkbox 16x16 (icono: cuadro) para "Seleccione los días...".
  Widget _buildCheckboxTile({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 32,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Center(
                child: value
                    ? Container(
                        width: 16,
                        height: 16,
                        color: const Color(0xFF007AC2),
                        child: const Icon(
                          Icons.check,
                          size: 12,
                          color: Color(0xFFFFFFFF),
                        ),
                      )
                    : AppIcon(
                        SvgIcon.cuadro,
                        width: 16,
                        height: 16,
                        color: const Color(0xFF949494),
                      ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontWeight: Fonts.wRegular,
                fontSize: Fonts.text0h,
                height: 20 / 16,
                color: Color(0xFF141414),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Checkbox 14x14 (icono: cuadro) para "Autorizo el tratamiento...".
  /// [showLink] resalta "Términos y Condiciones" en azul y lo hace tappable.
  Widget _buildTermsCheckbox({
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showLink,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(!value),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: value
                  ? Container(
                      width: 14,
                      height: 14,
                      color: const Color(0xFF007AC2),
                      child: const Icon(
                        Icons.check,
                        size: 11,
                        color: Color(0xFFFFFFFF),
                      ),
                    )
                  : AppIcon(
                      SvgIcon.cuadro,
                      width: 14,
                      height: 14,
                      color: const Color(0xFF949494),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: showLink
                  ? RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontFamily: Fonts.light,
                          fontWeight: Fonts.wLight,
                          fontSize: 14,
                          height: 16 / 14,
                          color: Color(0xFF141414),
                        ),
                        children: [
                          const TextSpan(
                            text:
                                'Autorizo el tratamiento de mis datos y acepto los ',
                          ),
                          TextSpan(
                            text: 'Términos y Condiciones.',
                            style: const TextStyle(
                              color: Color(0xFF007AC2),
                            ),
                            // Abre «Política de privacidad | Esri Colombia».
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => PoliticaPrivacidadModal.mostrar(
                                    context,
                                  ),
                          ),
                        ],
                      ),
                    )
                  : const Text(
                      'Autorizo el tratamiento de mis datos y acepto los '
                      'Términos y Condiciones.',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontWeight: Fonts.wLight,
                        fontSize: 14,
                        height: 16 / 14,
                        color: Color(0xFF141414),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
