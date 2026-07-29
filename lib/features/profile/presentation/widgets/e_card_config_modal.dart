import 'package:flutter/material.dart';
import '../../../../core/constants/fonts.dart';
import '../../data/ecard_visibility_config.dart';

class ECardConfigModal extends StatefulWidget {
  final ECardVisibilityConfig initialConfig;

  const ECardConfigModal({
    super.key,
    required this.initialConfig,
  });

  @override
  State<ECardConfigModal> createState() => _ECardConfigModalState();
}

class _ECardConfigModalState extends State<ECardConfigModal> {
  late bool _cargo;
  late bool _empresa;
  late bool _correo;
  late bool _telefono;

  @override
  void initState() {
    super.initState();
    _cargo = widget.initialConfig.cargo;
    _empresa = widget.initialConfig.empresa;
    _correo = widget.initialConfig.correo;
    _telefono = widget.initialConfig.telefono;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      // Baja la posición de la tarjeta respecto al centro predeterminado
      alignment: const Alignment(0, 0.05),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 358,
        height: 378, // Altura exacta del panel-container
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            /// --- HEADER (358x69px) ---
            Container(
              width: 358,
              height: 69,
              padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  /// text-content (282x32px)
                  const SizedBox(
                    width: 282,
                    height: 32,
                    child: Text(
                      'Configure su e-card',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        height: 32 / 26,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// close-action (36x32px)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 36,
                      height: 32,
                      padding: const EdgeInsets.only(right: 4),
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// --- CONTENT CONTAINER (358x216px) ---
            /// --- CONTENT CONTAINER (358x216px) ---
Container(
  width: 358,
  height: 216,
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 318,
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
  'Seleccione qué información desea mostrar cuando alguien escanee su tarjeta digital.',
  maxLines: 2,
  style: const TextStyle(
    fontFamily: Fonts.regular,
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -0.35,
  ),
)
        ),
      ),

      const SizedBox(height: 8),

      SizedBox(
        width: 318,
        height: 128,
        child: Column(
          children: [
            _ConfigToggleRow(
              label: ' Cargo',
              value: _cargo,
              onChanged: (v) => setState(() => _cargo = v),
            ),
            _ConfigToggleRow(
              label: ' Empresa',
              value: _empresa,
              onChanged: (v) => setState(() => _empresa = v),
            ),
            _ConfigToggleRow(
              label: ' Correo electrónico',
              value: _correo,
              onChanged: (v) => setState(() => _correo = v),
            ),
            _ConfigToggleRow(
              label: ' Número de teléfono',
              value: _telefono,
              onChanged: (v) => setState(() => _telefono = v),
            ),
          ],
        ),
      ),
    ],
  ),
),

            /// --- FOOTER (358x93px) ---
            Container(
              width: 358,
              height: 93,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: SizedBox(
                width: 318,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      ECardVisibilityConfig(
                        cargo: _cargo,
                        empresa: _empresa,
                        correo: _correo,
                        telefono: _telefono,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF007AC2),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: const Text(
                    'Guardar cambios',
                    textAlign: TextAlign.center,
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

class _ConfigToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ConfigToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      height: 32,
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// List item label (262x20px)
          SizedBox(
            width: 262,
            height: 20,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 20 / 16,
                color: Color(0xFF141414),
              ),
            ),
          ),

          /// Switch (32x16px)
          GestureDetector(
            onTap: () => onChanged(!value),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              width: 32.0,
              height: 16.0,
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999.0),
                color: value ? const Color(0xFF007AC2) : const Color(0xFFD6D6D6),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

