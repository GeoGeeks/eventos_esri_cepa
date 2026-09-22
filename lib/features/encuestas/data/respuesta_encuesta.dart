/// Lo que este asistente respondió para UNA pregunta puntual - parte de
/// [RespuestaEncuesta.respuestasPorPregunta]. Espejo de lectura de
/// `RespuestaPregunta`/`RespuestaOpcion` en `eventos_esri_cepa_api`.
class RespuestaPreguntaGuardada {
  const RespuestaPreguntaGuardada({
    required this.preguntaId,
    this.valorTexto,
    this.valorCalificacion,
    this.opcionIds = const [],
  });

  final String preguntaId;
  final String? valorTexto;
  final int? valorCalificacion;
  final List<String> opcionIds;

  factory RespuestaPreguntaGuardada.fromJson(Map<String, dynamic> json) {
    return RespuestaPreguntaGuardada(
      preguntaId: json['preguntaId'] as String,
      valorTexto: json['valorTexto'] as String?,
      valorCalificacion: json['valorCalificacion'] as int?,
      opcionIds: (json['opciones'] as List<dynamic>? ?? [])
          .map((e) => (e as Map<String, dynamic>)['opcionId'] as String)
          .toList(),
    );
  }
}

/// La respuesta completa de este asistente a una [Encuesta] - lo que
/// devuelven `POST /encuestas/:id/respuestas` y
/// `GET /encuestas/:id/mi-respuesta` de `eventos_esri_cepa_api` (ver
/// `RespuestaEncuesta` en ese repo).
class RespuestaEncuesta {
  const RespuestaEncuesta({
    required this.id,
    required this.encuestaId,
    required this.respuestasPorPregunta,
  });

  final String id;
  final String encuestaId;

  /// Indexadas por `preguntaId` - lo que necesita la vista de solo lectura
  /// ("Ver respuestas") para pintar el valor de cada pregunta sin recorrer
  /// la lista en cada `build`.
  final Map<String, RespuestaPreguntaGuardada> respuestasPorPregunta;

  factory RespuestaEncuesta.fromJson(Map<String, dynamic> json) {
    final lista = (json['respuestasPregunta'] as List<dynamic>? ?? [])
        .map(
          (e) => RespuestaPreguntaGuardada.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return RespuestaEncuesta(
      id: json['id'] as String,
      encuestaId: json['encuestaId'] as String,
      respuestasPorPregunta: {for (final r in lista) r.preguntaId: r},
    );
  }
}
