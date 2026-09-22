/// Opción de respuesta de una [Pregunta] `seleccion`/`seleccion_multiple`,
/// tal como la devuelve `eventos_esri_cepa_api` (ver `OpcionPregunta` en ese
/// repo).
class OpcionPregunta {
  const OpcionPregunta({required this.id, required this.texto});

  final String id;
  final String texto;

  factory OpcionPregunta.fromJson(Map<String, dynamic> json) {
    return OpcionPregunta(
      id: json['id'] as String,
      texto: json['texto'] as String,
    );
  }
}
