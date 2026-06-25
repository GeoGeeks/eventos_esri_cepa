import 'package:flutter/material.dart';

class ECardConfigModal extends StatefulWidget {
  const ECardConfigModal({super.key});

  @override
  State<ECardConfigModal> createState() =>
      _ECardConfigModalState();
}

class _ECardConfigModalState
    extends State<ECardConfigModal> {
  bool mostrarEmpresa = true;
  bool mostrarCargo = true;
  bool mostrarCorreo = false;
  bool mostrarTelefono = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración E-card',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF091F44),
              ),
            ),

            const SizedBox(height: 24),

            _OptionTile(
              title: 'Mostrar empresa',
              value: mostrarEmpresa,
              onChanged: (value) {
                setState(() {
                  mostrarEmpresa = value;
                });
              },
            ),

            _OptionTile(
              title: 'Mostrar cargo',
              value: mostrarCargo,
              onChanged: (value) {
                setState(() {
                  mostrarCargo = value;
                });
              },
            ),

            _OptionTile(
              title: 'Mostrar correo',
              value: mostrarCorreo,
              onChanged: (value) {
                setState(() {
                  mostrarCorreo = value;
                });
              },
            ),

            _OptionTile(
              title: 'Mostrar teléfono',
              value: mostrarTelefono,
              onChanged: (value) {
                setState(() {
                  mostrarTelefono = value;
                });
              },
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF091F44),
                      side: const BorderSide(
                        color: Color(0xFF091F44),
                      ),
                    ),
                    child: const Text(
                      'Cancelar',
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF091F44),
                    ),
                    child: const Text(
                      'Guardar',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _OptionTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF333333),
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF007AC2),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}