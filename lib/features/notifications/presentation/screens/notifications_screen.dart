import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/utils/area_segura.dart';
import '../widgets/empty_notifications.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const String _eliminarIcon = 'assets/icons/eliminar.svg';

  static final Color _deleteRedLight =
      AppColors.requiredField.withOpacity(0.05);

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
      backgroundColor: AppColors.background,
      // top:false — el título se coloca con AreaSegura para respetar los 36
      // de Figma cuando la barra de estado no llega a taparlos.
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 360,
            child: Padding(
              padding: EdgeInsets.only(
                top: AreaSegura.top(context, 36),
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER: Siempre visible
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificaciones',
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontWeight: Fonts.wMedium,
                          fontSize: Fonts.text3h, // 26px
                          height: 32 / 26,
                          color: AppColors.textTitle,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => notifications.clear()),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.chipBg,
                            border: Border.all(
                              color: AppColors.chipBg,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Borrar todo',
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontWeight: Fonts.wMedium,
                              fontSize: 14,
                              height: 16 / 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// CONTENIDO: Lista o Estado Vacío
                  Expanded(
                    child: notifications.isEmpty
                        ? const Center(
                            child: EmptyNotifications(),
                          )
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (final entry in groups.entries) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontFamily: Fonts.medium,
                                        fontWeight: Fonts.wMedium,
                                        fontSize: Fonts.text0h, // 16px
                                        height: 20 / 16,
                                        color: AppColors.modalSubtitle,
                                      ),
                                    ),
                                  ),
                                  for (final item in entry.value)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Dismissible(
                                        key: Key(item['id']),
                                        direction: DismissDirection.endToStart,
                                        background: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: _deleteRedLight,
                                                  borderRadius:
                                                      const BorderRadius
                                                          .horizontal(
                                                    left: Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 48,
                                              height: 88,
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                color: AppColors.requiredField,
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                  right: Radius.circular(8),
                                                ),
                                              ),
                                              child: SvgPicture.asset(
                                                _eliminarIcon,
                                                width: 24,
                                                height: 24,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  AppColors.white,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                            ),
                                          ],
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
