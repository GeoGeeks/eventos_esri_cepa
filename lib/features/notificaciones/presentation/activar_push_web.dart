import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../data/push_notificaciones_service.dart';

/// Tarjeta "Activar notificaciones" de la PWA (Android usa la PWA mientras
/// Google aprueba la app nativa). El navegador solo muestra el permiso tras
/// un toque del usuario, por eso es un botón y no se pide al entrar.
///
/// En Android/iOS nativos, o si el push web no está disponible, no ocupa
/// espacio. Tampoco se muestra si el permiso ya se concedió.
class ActivarPushWeb extends StatefulWidget {
  const ActivarPushWeb({super.key, this.push, this.disponible});

  /// Seams de test.
  final PushNotificacionesService? push;
  final bool? disponible;

  @override
  State<ActivarPushWeb> createState() => _ActivarPushWebState();
}

class _ActivarPushWebState extends State<ActivarPushWeb> {
  late final PushNotificacionesService _push =
      widget.push ?? PushNotificacionesService();

  AuthorizationStatus? _permiso;
  bool _activando = false;

  bool get _disponible =>
      widget.disponible ?? PushNotificacionesService.pushWebDisponible;

  @override
  void initState() {
    super.initState();
    if (_disponible) _leerPermiso();
  }

  Future<void> _leerPermiso() async {
    try {
      final permiso = await _push.permisoWeb();
      if (mounted) setState(() => _permiso = permiso);
    } catch (_) {
      // Sin poder leer el permiso, simplemente no se ofrece el botón.
    }
  }

  Future<void> _activar() async {
    setState(() => _activando = true);
    bool activadas = false;
    try {
      activadas = await _push.activarEnWeb();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _activando = false;
      if (activadas) _permiso = AuthorizationStatus.authorized;
    });
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        content: Text(
          activadas
              ? 'Listo: recibirá las notificaciones del evento en este dispositivo.'
              : 'No se activaron. Revise que las notificaciones de este sitio estén permitidas en su navegador.',
        ),
      ),
    );
    if (!activadas) await _leerPermiso();
  }

  @override
  Widget build(BuildContext context) {
    final permiso = _permiso;
    if (!_disponible ||
        permiso == null ||
        permiso == AuthorizationStatus.authorized) {
      return const SizedBox.shrink();
    }

    final bloqueadas = permiso == AuthorizationStatus.denied;
    return Container(
      key: const Key('activar-push-web'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bloqueadas
                ? 'Las notificaciones de este sitio están bloqueadas en su navegador. Para recibir los avisos del evento, permítalas en la configuración del sitio.'
                : 'Reciba en este dispositivo los avisos del evento: cambios de agenda, recordatorios y novedades.',
            style: const TextStyle(
              fontFamily: Fonts.regular,
              fontWeight: Fonts.wRegular,
              fontSize: 14,
              height: 20 / 14,
              color: AppColors.textTitle,
            ),
          ),
          if (!bloqueadas) ...[
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _activando ? null : _activar,
              child: Text(_activando ? 'Activando…' : 'Activar notificaciones'),
            ),
          ],
        ],
      ),
    );
  }
}
