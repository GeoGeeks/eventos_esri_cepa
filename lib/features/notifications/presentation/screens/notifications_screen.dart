import 'package:flutter/material.dart';

import '../widgets/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Borrar todo',
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hoy',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            const NotificationItem(
              title: 'Actualización del evento',
              description:
                  'Se ha modificado la hora de inicio.',
              date: '20/06',
              isNew: true,
            ),

            const NotificationItem(
              title: 'Actualización del evento',
              description:
                  'Se ha modificado la hora de inicio.',
              date: '19/06',
            ),

            const SizedBox(height: 16),

            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Semana pasada',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: const [
                  NotificationItem(
                    title:
                        'Actualización del evento',
                    description:
                        'Se ha modificado la hora de inicio.',
                    date: '19/06',
                  ),
                  NotificationItem(
                    title:
                        'Actualización del evento',
                    description:
                        'Se ha modificado la hora de inicio.',
                    date: '19/06',
                  ),
                  NotificationItem(
                    title:
                        'Actualización del evento',
                    description:
                        'Se ha modificado la hora de inicio.',
                    date: '19/06',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}