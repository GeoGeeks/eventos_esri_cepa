import 'pregunta.dart';

/// Encuesta de un evento, tal como la devuelve `eventos_esri_cepa_api` (ver
/// `Encuesta` en ese repo). `tipo` distingue la encuesta `'post_evento'`
/// (única por evento, la que habilita el certificado) de las N encuestas
/// `'modulo'` (pestaña "Encuestas" dentro del evento).
class Encuesta {
  const Encuesta({
    required this.id,
    required this.idEvento,
    required this.tipo,
    required this.titulo,
    this.preguntas = const [],
    this.yaRespondida = false,
  });

  final String id;
  final String idEvento;

  /// `'post_evento'` o `'modulo'` - sin enum propio porque, a diferencia de
  /// [TipoPregunta], esta app nunca necesita distinguir un tercer valor: el
  /// único uso es filtrar la lista de "Encuestas" del evento a `'modulo'`
  /// (ya lo hace el propio backend, `GET /eventos/:idEvento/encuestas`) y
  /// resolver la `post_evento` por su endpoint dedicado.
  final String tipo;

  final String titulo;

  /// En el orden en que las ordena `orden` (ver `Pregunta`) - `fromJson` las
  /// ordena aquí para que la paginación de [PaginadorPreguntas] no dependa
  /// de que el backend ya las mande ordenadas.
  final List<Pregunta> preguntas;

  /// Solo viene en `GET /eventos/:idEvento/encuestas` (el listado de la
  /// pestaña) - en el resto de endpoints (detalle, post-evento) queda en
  /// `false` por defecto; esos casos resuelven "¿ya respondió?" con
  /// `GET /encuestas/:id/mi-respuesta` en su lugar (ver
  /// `EncuestasRepository.miRespuesta`).
  final bool yaRespondida;

  factory Encuesta.fromJson(Map<String, dynamic> json) {
    final preguntas = (json['preguntas'] as List<dynamic>? ?? [])
        .map((e) => Pregunta.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.orden.compareTo(b.orden));
    return Encuesta(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      tipo: json['tipo'] as String,
      titulo: json['titulo'] as String,
      preguntas: preguntas,
      yaRespondida: json['yaRespondida'] as bool? ?? false,
    );
  }
}
