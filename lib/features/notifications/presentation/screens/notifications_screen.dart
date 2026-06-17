import 'package:flutter/material.dart';

import '../widgets/empty_notifications.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Actualización del evento',
      'description':
          'Se ha modificado la hora de inicio.',
      'date': '20/06',
      'isNew': true,
    },
    {
      'id': '2',
      'title': 'Actualización del evento',
      'description':
          'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
    },
    {
      'id': '3',
      'title': 'Actualización del evento',
      'description':
          'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
    },
    {
      'id': '4',
      'title': 'Actualización del evento',
      'description':
          'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
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
                    onPressed: notifications.isEmpty
                        ? null
                        : () {
                            setState(() {
                              notifications.clear();
                            });
                          },
                    child: const Text(
                      'Borrar todo',
                    ),
                  ),
                ],
              ),
            ),

            if (!notifications.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hoy',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            Expanded(
              child: notifications.isEmpty
                  ? const EmptyNotifications()
                  : ListView.builder(
                      itemCount:
                          notifications.length,
                      itemBuilder:
                          (context, index) {
                        final notification =
                            notifications[
                                index];

                        return Dismissible(
                          key: Key(
                            notification['id'],
                          ),
                          direction:
                              DismissDirection
                                  .endToStart,
                          background:
                              Container(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  16,
                              vertical: 6,
                            ),
                            alignment:
                                Alignment
                                    .centerRight,
                            padding:
                                const EdgeInsets
                                    .only(
                              right: 20,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.red,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                            child:
                                const Icon(
                              Icons.delete,
                              color: Colors
                                  .white,
                            ),
                          ),
                          onDismissed: (_) {
                            setState(() {
                              notifications
                                  .removeAt(
                                index,
                              );
                            });
                          },
                          child:
                              NotificationItem(
                            title:
                                notification[
                                    'title'],
                            description:
                                notification[
                                    'description'],
                            date:
                                notification[
                                    'date'],
                            isNew:
                                notification[
                                    'isNew'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}