import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';

class ECardConfigModal extends StatefulWidget {
  const ECardConfigModal({super.key});

  @override
  State<ECardConfigModal> createState() => _ECardConfigModalState();
}

class _ECardConfigModalState extends State<ECardConfigModal> {
  bool _cargo = true;
  bool _empresa = true;
  bool _correo = true;
  bool _telefono = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 100,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Configure su e-card',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textTitle,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.textSubtle,
                    size: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            const Text(
              'Seleccione qué información desea mostrar cuando alguien escanee su tarjeta digital.',
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 13,
                color: AppColors.textSubtle,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            _ConfigToggle(
              label: 'Cargo',
              value: _cargo,
              onChanged: (v) => setState(() => _cargo = v),
            ),
            _ConfigToggle(
              label: 'Empresa',
              value: _empresa,
              onChanged: (v) => setState(() => _empresa = v),
            ),
            _ConfigToggle(
              label: 'Correo electrónico',
              value: _correo,
              onChanged: (v) => setState(() => _correo = v),
            ),
            _ConfigToggle(
              label: 'Número de teléfono',
              value: _telefono,
              onChanged: (v) => setState(() => _telefono = v),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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

class _ConfigToggle extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ConfigToggle({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 14,
            color: AppColors.textTitle,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: AppColors.primary,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}