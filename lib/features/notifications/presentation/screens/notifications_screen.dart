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
  final List<Map<String, dynamic>>
      notifications = [
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
    {
      'id': '5',
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
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                12,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  const Text(
                    'Notificaciones',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF222222),
                    ),
                  ),
                  Container(
                    height: 34,
                    decoration:
                        BoxDecoration(
                      color: const Color(
                        0xFFEAF5FF,
                      ),
                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),
                    child: TextButton(
                      onPressed:
                          notifications
                                  .isEmpty
                              ? null
                              : () {
                                  setState(
                                    () {
                                      notifications
                                          .clear();
                                    },
                                  );
                                },
                      child: const Text(
                        'Borrar todo',
                        style: TextStyle(
                          color: Color(
                            0xFF7D9AB5,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (notifications
                .isNotEmpty) ...[
              const Padding(
                padding:
                    EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Align(
                  alignment:
                      Alignment
                          .centerLeft,
                  child: Text(
                    'Hoy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight
                              .w500,
                      color: Color(
                        0xFF555555,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],

            Expanded(
              child: notifications
                      .isEmpty
                  ? const EmptyNotifications()
                  : ListView.builder(
                      padding:
                          const EdgeInsets
                              .only(
                        bottom: 24,
                      ),
                      itemCount:
                          notifications
                              .length,
                      itemBuilder:
                          (
                            context,
                            index,
                          ) {
                        final item =
                            notifications[
                                index];

                        return Dismissible(
                          key: Key(
                            item['id'],
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
                              vertical:
                                  6,
                            ),
                            alignment:
                                Alignment
                                    .centerRight,
                            padding:
                                const EdgeInsets
                                    .only(
                              right: 24,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.red,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                            ),
                            child:
                                const Icon(
                              Icons.delete,
                              color: Colors
                                  .white,
                            ),
                          ),
                          onDismissed:
                              (_) {
                            setState(
                              () {
                                notifications
                                    .removeAt(
                                  index,
                                );
                              },
                            );
                          },
                          child:
                              NotificationItem(
                            title:
                                item[
                                    'title'],
                            description:
                                item[
                                    'description'],
                            date:
                                item[
                                    'date'],
                            isNew:
                                item[
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