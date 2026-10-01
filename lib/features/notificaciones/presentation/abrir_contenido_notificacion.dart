import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../agenda/agenda.dart';
import '../../agenda/data/agenda_repository.dart';
import '../../valoraciones/data/valoraciones_repository.dart';
import '../data/accion_notificacion.dart';

/// Abre el contenido vinculado de una notificación - el mismo camino al
/// tocar el push del sistema (`PushNotificacionesService`) y "Revise los
/// detalles" en Alertas (`NotificationsScreen`):
/// - [AbrirEnlace]: el navegador del dispositivo.
/// - [AbrirCharla]: la agenda de su evento con la charla desplegada. El
///   evento se resuelve con `GET /charlas/:id`, porque la notificación solo
///   trae el id de la charla.
///
/// [agendaRepository], [valoracionesRepository] y [abrirUrl] son seams
/// para tests.
Future<void> abrirContenidoNotificacion(
  NavigatorState navegador,
  AccionNotificacion accion, {
  AgendaRepository? agendaRepository,
  ValoracionesRepository? valoracionesRepository,
  Future<bool> Function(Uri uri)? abrirUrl,
}) async {
  switch (accion) {
    case AbrirEnlace(:final uri):
      final abrir =
          abrirUrl ??
          (Uri u) => launchUrl(u, mode: LaunchMode.externalApplication);
      await abrir(uri);
    case AbrirCharla(:final idCharla):
      try {
        final charla = await (agendaRepository ?? AgendaRepository())
            .obtenerCharla(idCharla);
        if (!navegador.mounted) return;
        await navegador.push(
          MaterialPageRoute<void>(
            builder: (_) => AgendaScreen(
              idEvento: charla.idEvento,
              idCharlaDestacada: charla.id,
              repository: agendaRepository,
              valoracionesRepository: valoracionesRepository,
            ),
          ),
        );
      } catch (e) {
        debugPrint('[abrirContenidoNotificacion] charla $idCharla: $e');
        if (navegador.mounted) {
          mostrarSnackBar(
            navegador.context,
            'No se pudo abrir la actividad de esta notificación. Intente de nuevo.',
          );
        }
      }
  }
}
