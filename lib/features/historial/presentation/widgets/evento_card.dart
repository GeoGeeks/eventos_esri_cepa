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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF9C7BEB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.event,
              color: Colors.white,
              size: 40,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        evento.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        evento.presencial
                            ? 'Presencial'
                            : 'Virtual',
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  evento.fecha,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                Text(
                  evento.direccion,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DetalleEventoModal(
                            evento: evento,
                          ),
                        );
                      },
                      child: const Text(
                        'Ver más',
                      ),
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
                      child: const Text(
                        'Registrarse',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}