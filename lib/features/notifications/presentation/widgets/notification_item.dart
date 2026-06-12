import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final bool isNew;

  const NotificationItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isNew
            ? const Color(0xFFF3F7FA)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFDDF1FF),
            child: Icon(
              Icons.event_note_outlined,
              color: Color(0xFF007AC2),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Revise los detalles',
                  style: TextStyle(
                    color: Color(0xFF091F44),
                    fontSize: 12,
                    decoration:
                        TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),

          Column(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              if (isNew)
                Container(
                  margin:
                      const EdgeInsets.only(top: 8),
                  width: 8,
                  height: 8,
                  decoration:
                      const BoxDecoration(
                    color: Color(0xFF007AC2),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}