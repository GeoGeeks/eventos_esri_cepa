import 'package:flutter/material.dart';

import '../../data/eventos_data.dart';
import 'detalle_evento_modal.dart';

class HistorialEventCard extends StatelessWidget {
  final Evento evento;

  const HistorialEventCard({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomLeft: Radius.circular(4),
            ),
            child: Image.asset(
              evento.image,
              width: 105,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          evento.titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 4),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          evento.presencial ? 'Presencial' : 'Virtual',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${evento.fecha} - ${evento.hora}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          evento.direccion,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 13,
                        color: Color(0xFFF39C12),
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          evento.estado,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFF39C12),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF091F44),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}