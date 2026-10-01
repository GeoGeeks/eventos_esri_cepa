import 'dart:convert';

/// A dónde lleva tocar una notificación, según el contenido vinculado que
/// le puso el panel a la campaña (`Notificacion.accionRuta`/`accionParams`
/// en `eventos_esri_cepa_api`). Solo existe si la campaña lo trae: sin
/// contenido vinculado, tocarla no navega a ningún lado (PO, 2026-09-30).
sealed class AccionNotificacion {
  const AccionNotificacion();

  /// Ruta que usa el panel para vincular una charla de la agenda.
  static const rutaCharla = 'agenda/detalle';

  /// `null` si la campaña no trae contenido vinculado o trae uno que esta
  /// versión de la app no sabe abrir (ignorarlo es mejor que fallar).
  static AccionNotificacion? desde(String? ruta, String? params) {
    if (ruta == null || ruta.trim().isEmpty) return null;
    final limpia = ruta.trim();
    if (limpia == rutaCharla) {
      final idCharla = _leerParams(params)['idCharla'];
      return idCharla is String && idCharla.isNotEmpty
          ? AbrirCharla(idCharla)
          : null;
    }
    final uri = Uri.tryParse(limpia);
    if (uri != null && (uri.scheme == 'http' || uri.scheme == 'https')) {
      return AbrirEnlace(uri);
    }
    return null;
  }

  /// Lo mismo, desde el payload `data` de FCM (todo string).
  static AccionNotificacion? desdeData(Map<String, dynamic> data) =>
      desde(data['accionRuta'] as String?, data['accionParams'] as String?);

  static Map<String, dynamic> _leerParams(String? params) {
    if (params == null || params.isEmpty) return const {};
    try {
      final json = jsonDecode(params);
      return json is Map<String, dynamic> ? json : const {};
    } on FormatException {
      return const {};
    }
  }
}

/// Enlace externo (p. ej. una página de esri.co): se abre en el navegador.
class AbrirEnlace extends AccionNotificacion {
  const AbrirEnlace(this.uri);
  final Uri uri;
}

/// Una charla de la agenda: se abre la agenda de su evento con ella
/// desplegada.
class AbrirCharla extends AccionNotificacion {
  const AbrirCharla(this.idCharla);
  final String idCharla;
}
