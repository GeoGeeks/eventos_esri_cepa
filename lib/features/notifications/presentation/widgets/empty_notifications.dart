import 'package:flutter/material.dart';

class EmptyNotifications
    extends StatelessWidget {
  const EmptyNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 120,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 28),

            const Text(
              'No tienes notificaciones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Cuando recibas una notificación,\nla verás aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFFA0A0A0),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}