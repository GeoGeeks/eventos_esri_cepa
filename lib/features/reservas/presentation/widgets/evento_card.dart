import 'package:flutter/material.dart';

import '../../data/eventos_data.dart';
import 'detalle_evento_modal.dart';

class EventoCard extends StatelessWidget {
  final Evento evento;

  const EventoCard({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              evento.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(evento.fecha),
            Text(evento.hora),
            Text(evento.direccion),

            const SizedBox(height: 16),

            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          DetalleEventoModal(
                        evento: evento,
                      ),
                    );
                  },
                  child: const Text('Ver más'),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          'Registro exitoso en ${evento.titulo}',
                        ),
                      ),
                    );
                  },
                  child:
                      const Text('Registrarse'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}