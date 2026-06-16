import 'package:flutter/material.dart';

import '../../data/eventos_data.dart';

class DetalleEventoModal extends StatelessWidget {
  final Evento evento;

  const DetalleEventoModal({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        evento.titulo,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_month,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(evento.fecha),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(evento.hora),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(evento.direccion),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Es un evento diseñado para compartir experiencias, soluciones e innovación en el mundo GIS.',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cerrar',
          ),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Registro exitoso en ${evento.titulo}',
                ),
              ),
            );
          },
          child: const Text(
            'Registrarse',
          ),
        ),
      ],
    );
  }
}