import 'package:flutter/material.dart';

class PostEventInfo extends StatelessWidget {
  const PostEventInfo({super.key});

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF091F44);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: iconColor),
              const SizedBox(width: 8),
              const Text('Octubre 02, 2026'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: iconColor),
              const SizedBox(width: 8),
              const Text('8:00 - 11:00'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: iconColor),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Universidad Central Cra 36 #24 - 45'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
          ),
        ],
      ),
    );
  }
}