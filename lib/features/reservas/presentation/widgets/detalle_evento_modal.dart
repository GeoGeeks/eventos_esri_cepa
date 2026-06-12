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
      title: Text(evento.titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(evento.fecha),
          Text(evento.hora),
          Text(evento.direccion),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}