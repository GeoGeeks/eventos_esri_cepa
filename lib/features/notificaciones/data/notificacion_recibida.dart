/// Un push ya recibido, tal como lo devuelve
/// `GET /notificaciones/mis-notificaciones` de `eventos_esri_cepa_api` -
/// contenido de la campaña ya aplanado sobre el envío puntual del propio
/// asistente.
class NotificacionRecibida {
  const NotificacionRecibida({
    required this.id,
    required this.notificacionId,
    required this.titulo,
    required this.cuerpo,
    this.imagenUrl,
    this.accionRuta,
    this.accionParams,
    required this.leida,
    required this.fecha,
  });

  /// Id del `NotificacionEnvio` - lo que identifica ESTE envío puntual (no
  /// el de la campaña) para "Borrar todo"/swipe-to-dismiss.
  final String id;
  final String notificacionId;
  final String titulo;
  final String cuerpo;
  final String? imagenUrl;
  final String? accionRuta;

  /// JSON crudo tal como lo guarda el backend - ver
  /// `Notificacion.accionParams` en `eventos_esri_cepa_api`. Sin parsear
  /// todavía: no hay quien lo consuma aún (ver el gap de deep link
  /// documentado en `PushNotificacionesService`).
  final String? accionParams;

  final bool leida;
  final DateTime fecha;

  /// "20/06" - mismo formato que ya usaba el mock de `NotificationsScreen`.
  String get fechaFormateada {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    return '$dia/$mes';
  }

  /// Encabezado de grupo en la pantalla de Notificaciones - "Hoy" para lo
  /// del día de hoy, "Semana pasada" para todo lo demás. Mismos dos grupos
  /// que ya traía el mock; si hace falta un grupo intermedio ("Esta
  /// semana", "Este mes") se puede afinar cuando el diseño lo pida.
  String get grupo {
    final hoy = DateTime.now();
    final esHoy = fecha.year == hoy.year &&
        fecha.month == hoy.month &&
        fecha.day == hoy.day;
    return esHoy ? 'Hoy' : 'Semana pasada';
  }

  factory NotificacionRecibida.fromJson(Map<String, dynamic> json) {
    return NotificacionRecibida(
      id: json['id'] as String,
      notificacionId: json['notificacionId'] as String,
      titulo: json['titulo'] as String,
      cuerpo: json['cuerpo'] as String,
      imagenUrl: json['imagenUrl'] as String?,
      accionRuta: json['accionRuta'] as String?,
      accionParams: json['accionParams'] as String?,
      // 'LEIDO' es el único estado de envío que representa que el
      // asistente ya la abrió (ver EstadoEnvioNotificacion en el backend) -
      // el resto (ENVIADO/ENTREGADO/FALLIDO) cuenta como "nueva".
      leida: json['estado'] == 'LEIDO',
      fecha: DateTime.parse(json['createdAt'] as String),
    );
  }
}
