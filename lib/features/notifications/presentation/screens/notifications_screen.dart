import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../notificaciones/data/notificacion_recibida.dart';
import '../../../notificaciones/data/notificaciones_repository.dart';
import '../widgets/empty_notifications.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  /// Seam para tests (inyectar un doble sin red real) - mismo patrón que
  /// `Menu({pushNotificaciones})`.
  final NotificacionesRepository? repository;

  const NotificationsScreen({super.key, this.repository});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const String _eliminarIcon = 'assets/icons/eliminar.svg';

  static final Color _deleteRedLight =
      AppColors.requiredField.withOpacity(0.05);

  late final NotificacionesRepository _repository =
      widget.repository ?? NotificacionesRepository();

  bool _cargando = true;
  String? _mensajeError;
  List<NotificacionRecibida> _notificaciones = const [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });
    try {
      final notificaciones = await _repository.listarMisNotificaciones();
      if (!mounted) return;
      setState(() {
        _notificaciones = notificaciones;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _mensajeError =
            'No se pudieron cargar las notificaciones. Intenta de nuevo.';
        _cargando = false;
      });
    }
  }

  /// Optimista: limpia la lista de una vez y solo la restaura si el borrado
  /// en el backend falla - "Borrar todo" no tiene diálogo de confirmación
  /// en el diseño original, así que tampoco lo agrega esta conexión.
  Future<void> _borrarTodo() async {
    final anteriores = _notificaciones;
    setState(() => _notificaciones = const []);
    try {
      await _repository.borrarTodas();
    } catch (_) {
      if (!mounted) return;
      setState(() => _notificaciones = anteriores);
    }
  }

  /// También optimista (el `Dismissible` ya animó la salida del ítem) - si
  /// falla, se vuelve a cargar la lista completa en vez de reinsertar el
  /// ítem a mano, para no pelear con la animación de salida ya en curso.
  Future<void> _borrarUna(NotificacionRecibida item) async {
    setState(
      () => _notificaciones =
          _notificaciones.where((n) => n.id != item.id).toList(),
    );
    try {
      await _repository.borrarUna(item.id);
    } catch (_) {
      await _cargar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<NotificacionRecibida>>{};
    for (final n in _notificaciones) {
      groups.putIfAbsent(n.grupo, () => []).add(n);
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
                        onTap: _notificaciones.isEmpty ? null : _borrarTodo,
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

                  /// CONTENIDO: cargando / error / lista o estado vacío
                  Expanded(
                    child: _cargando
                        ? const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : _mensajeError != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _mensajeError!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: Fonts.regular,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: _cargar,
                                        child: const Text('Reintentar'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _notificaciones.isEmpty
                                ? const Center(child: EmptyNotifications())
                                : SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (final entry in groups.entries) ...[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
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
                                              padding: const EdgeInsets.only(
                                                bottom: 12,
                                              ),
                                              child: Dismissible(
                                                key: Key(item.id),
                                                direction:
                                                    DismissDirection.endToStart,
                                                background: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color:
                                                              _deleteRedLight,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .horizontal(
                                                            left:
                                                                Radius.circular(
                                                              8,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 48,
                                                      height: 88,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: AppColors
                                                            .requiredField,
                                                        borderRadius:
                                                            BorderRadius
                                                                .horizontal(
                                                          right:
                                                              Radius.circular(
                                                            8,
                                                          ),
                                                        ),
                                                      ),
                                                      child: SvgPicture.asset(
                                                        _eliminarIcon,
                                                        width: 24,
                                                        height: 24,
                                                        colorFilter:
                                                            const ColorFilter
                                                                .mode(
                                                          AppColors.white,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onDismissed: (_) =>
                                                    _borrarUna(item),
                                                child: NotificationItem(
                                                  title: item.titulo,
                                                  description: item.cuerpo,
                                                  date: item.fechaFormateada,
                                                  isNew: !item.leida,
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
