import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 358,
        // Eliminamos height: 378 rígido para permitir que se adapte al contenido sin desbordarse
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Se ajusta al tamaño vertical necesario
          children: [
            /// --- HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Configure su e-card',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 22, // Ajustado ligeramente para evitar saltos de línea bruscos
                        fontWeight: FontWeight.w500,
                        height: 28 / 22,
                        color: Color(0xFF141414),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(2),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF6B6B6B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// --- CONTENT (Flexible + Scrollable si la pantalla es muy pequeña) ---
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtítulo / Label explicativo (SizedBox sin alto fijo para adaptarse a N líneas)
                    const Text(
                      'Seleccione qué información desea mostrar cuando alguien escanee su tarjeta digital.',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 20 / 15,
                        color: Color(0xFF141414),
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Lista de Opciones
                    _ConfigToggleRow(
                      label: 'Cargo',
                      value: _cargo,
                      onChanged: (v) => setState(() => _cargo = v),
                    ),
                    _ConfigToggleRow(
                      label: 'Empresa',
                      value: _empresa,
                      onChanged: (v) => setState(() => _empresa = v),
                    ),
                    _ConfigToggleRow(
                      label: 'Correo electrónico',
                      value: _correo,
                      onChanged: (v) => setState(() => _correo = v),
                    ),
                    _ConfigToggleRow(
                      label: 'Número de teléfono',
                      value: _telefono,
                      onChanged: (v) => setState(() => _telefono = v),
                    ),
                  ],
                ),
              ),
            ),

            /// --- FOOTER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F2F2), width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
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

/// Fila individual de Switch alineada al layout del CSS
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
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
          SizedBox(
            width: 36,
            height: 24,
            child: Transform.scale(
              scale: 0.75,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF007AC2),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFD6D6D6),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}