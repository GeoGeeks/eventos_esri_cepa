import 'dart:math' as math;

import 'package:flutter/material.dart';

// Constantes globales de tu arquitectura
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'valoracion_paso2_screen.dart';

class ValoracionPaso1Screen extends StatefulWidget {
  const ValoracionPaso1Screen({super.key});

  @override
  State<ValoracionPaso1Screen> createState() => _ValoracionPaso1ScreenState();
}

class _ValoracionPaso1ScreenState extends State<ValoracionPaso1Screen> {
  int rating = 0;

  bool dia1 = false;
  bool dia2 = false;
  bool dia3 = false;

  String? laboratorio;
  bool isMenuOpen = false; // ✅ Controla el estado del menú desplegable

  final TextEditingController _comentarioGeneralController =
      TextEditingController();
  final TextEditingController _comentarioLabController =
      TextEditingController();

  @override
  void dispose() {
    _comentarioGeneralController.dispose();
    _comentarioLabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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

              /// STEP-BARS (360x2, gap 12)
              Row(
                children: [
                  Expanded(
                    child: Container(height: 2, color: const Color(0xFF007AC2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(height: 2, color: const Color(0xFFD4D4D4)),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// RATING: ¿Qué le pareció?
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
                    TextSpan(text: '¿Qué le pareció?'),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFD83020)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// ESTRELLAS DE CALIFICACIÓN (32x32, gap 8) — icono: favoritos
              Row(
                children: List.generate(
                  5,
                  (i) => GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = i + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AppIcon(
                        rating > i ? SvgIcon.estrellaLlena : SvgIcon.favoritos,
                        width: 32,
                        height: 32,
                        color: rating > i
                            ? const Color(0xFF007AC2)
                            : const Color(0xFF949494),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CUÉNTANOS MÁS (1)
              const Text(
                'Cuéntanos más (Opcional)',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontWeight: Fonts.wRegular,
                  fontSize: Fonts.text0h,
                  height: 20 / 16,
                  color: Color(0xFF141414),
                ),
              ),

              const SizedBox(height: 8),

              _buildTextArea(_comentarioGeneralController),

              const SizedBox(height: 12),

              /// COMBOBOX: Participó en los Laboratorios de entrenamiento
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
                      text: 'Participó en los Laboratorios de entrenamiento',
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFD83020)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              /// content-container: padding 0px 10px 0px 16px (Figma spec)
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(color: const Color(0xFF949494), width: 1),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: laboratorio,
                    isExpanded: true,
                    onMenuStateChange: (isOpen) {
                      setState(() {
                        isMenuOpen = isOpen; // ✅ Detecta si abre o cierra
                      });
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
                            // ✅ Si el menú está abierto rota a 90° (arriba), si está cerrado a -90° (abajo)
                            angle: isMenuOpen ? math.pi / 2 : -math.pi / 2,
                            child: const AppIcon(
                              SvgIcon.back,
                              width: 8.414,
                              height: 14,
                              color: Color(0xFF6B6B6B),
                            ),
                          ),
                        ),
                      ),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      offset: const Offset(0, -2),
                      width: MediaQuery.of(context).size.width - 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    hint: const Text(
                      'Seleccione',
                      style: TextStyle(
                        fontFamily: Fonts.light,
                        fontWeight: Fonts.wLight,
                        fontSize: Fonts.text0h,
                        height: 20 / 16,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'si',
                        child: Text(
                          'Sí',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: Fonts.text0h,
                            color: Color(0xFF141414),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'no',
                        child: Text(
                          'No',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: Fonts.text0h,
                            color: Color(0xFF141414),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        laboratorio = v;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// CUÉNTANOS MÁS (2)
              const Text(
                'Cuéntanos más (Opcional)',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontWeight: Fonts.wRegular,
                  fontSize: Fonts.text0h,
                  height: 20 / 16,
                  color: Color(0xFF141414),
                ),
              ),

              const SizedBox(height: 8),

              _buildTextArea(_comentarioLabController),

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
                    TextSpan(text: 'Seleccione los días en los que participó'),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFD83020)),
                    ),
                  ],
                ),
              ),

              /// LISTA (checkboxes con icono cuadro, sin gap adicional)
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ValoracionPaso2Screen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Continuar',
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

  /// Textarea 360x132 con el detalle de "drag-handle" (líneas diagonales,
  /// icono: mensaje) en la esquina inferior derecha, tal como en Figma.
  Widget _buildTextArea(TextEditingController controller) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFF949494), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontSize: Fonts.text0h,
                color: Color(0xFF141414),
              ),
              decoration: InputDecoration(
                hintText: 'Escriba su comentario aquí...',
                hintStyle: const TextStyle(
                  fontFamily: Fonts.light,
                  fontWeight: Fonts.wLight,
                  fontSize: Fonts.text0h,
                  height: 20 / 16,
                  color: Color(0xFF6B6B6B),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: AppIcon(
              SvgIcon.mensaje,
              width: 9,
              height: 9,
              color: const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }

  /// Checkbox custom: sin marcar usa el icono "cuadro"; marcado usa un
  /// cuadro azul con check, replicando el estilo del resto de la app.
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
}
