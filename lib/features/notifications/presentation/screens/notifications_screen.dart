import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/empty_notifications.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const _fontFamily = 'Avenir Next LT Pro';
  static const _azul = Color(0xFF007AC2);
  static const _chipBg = Color(0xFFD6EFFF);
  static const _textDark = Color(0xFF141414);
  static const _textGray = Color(0xFF4A4A4A);
  static const _bgScreen = Color(0xFFF7F7F7);
  static const _deleteRed = Color(0xFFD83020);

  final List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'title': 'Actualización del evento',
      'description': 'Se ha modificado la hora de inicio.',
      'date': '20/06',
      'isNew': true,
      'group': 'Hoy',
    },
    {
      'id': '2',
      'title': 'Actualización del evento',
      'description': 'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
      'group': 'Hoy',
    },
    {
      'id': '3',
      'title': 'Actualización del evento',
      'description': 'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
      'group': 'Semana pasada',
    },
    {
      'id': '4',
      'title': 'Actualización del evento',
      'description': 'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
      'group': 'Semana pasada',
    },
    {
      'id': '5',
      'title': 'Actualización del evento',
      'description': 'Se ha modificado la hora de inicio.',
      'date': '19/06',
      'isNew': false,
      'group': 'Semana pasada',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<Map<String, dynamic>>>{};
    for (final n in notifications) {
      groups.putIfAbsent(n['group'] as String, () => []).add(n);
    }

    return Scaffold(
      backgroundColor: _bgScreen,
      body: SafeArea(
        child: Column(
          children: [
            // Header según CSS Figma
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 36, 26, 12),
              child: SizedBox(
                height: 32,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center, // Propiedad corregida
                  children: [
                    const Text(
                      'Notificaciones',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        height: 32 / 26,
                        color: _textDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: notifications.isEmpty
                          ? null
                          : () => setState(() => notifications.clear()),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _chipBg,
                          border: Border.all(color: _chipBg),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Borrar todo',
                          style: TextStyle(
                            fontFamily: _fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 16 / 14,
                            color: _azul,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenido dinámico
            Expanded(
              child: notifications.isEmpty
                  ? const EmptyNotifications()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
                      children: [
                        for (final entry in groups.entries) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontFamily: _fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 20 / 16,
                                color: _textGray,
                              ),
                            ),
                          ),
                          for (final item in entry.value)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Dismissible(
                                key: Key(item['id']),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  width: 48,
                                  height: 88,
                                  padding: const EdgeInsets.only(right: 12),
                                  decoration: const BoxDecoration(
                                    color: _deleteRed,
                                    borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(8),
                                    ),
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/icons/eliminar.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                onDismissed: (_) {
                                  setState(() {
                                    notifications.removeWhere(
                                      (n) => n['id'] == item['id'],
                                    );
                                  });
                                },
                                child: NotificationItem(
                                  title: item['title'],
                                  description: item['description'],
                                  date: item['date'],
                                  isNew: item['isNew'],
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
