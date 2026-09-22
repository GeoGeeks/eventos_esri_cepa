import 'opcion_pregunta.dart';

/// Los 4 tipos de pregunta que soporta `eventos_esri_cepa_api` - ver
/// `Pregunta.tipo` en ese repo.
enum TipoPregunta { abierta, seleccion, seleccionMultiple, calificacion }

TipoPregunta _tipoDesdeJson(String valor) {
  switch (valor) {
    case 'abierta':
      return TipoPregunta.abierta;
    case 'seleccion':
      return TipoPregunta.seleccion;
    case 'seleccion_multiple':
      return TipoPregunta.seleccionMultiple;
    case 'calificacion':
      return TipoPregunta.calificacion;
    default:
      // El backend es la fuente de verdad del enum - un valor desconocido
      // significa que este cliente quedó desactualizado, no que el dato esté
      // mal. `abierta` es el tipo más permisivo (texto libre), así que no
      // bloquea al usuario mientras se actualiza la app.
      return TipoPregunta.abierta;
  }
}

/// Pregunta de una [Encuesta], tal como la devuelve `eventos_esri_cepa_api`
/// (ver `Pregunta` en ese repo). `opciones` solo aplica a
/// [TipoPregunta.seleccion]/[TipoPregunta.seleccionMultiple].
class Pregunta {
  const Pregunta({
    required this.id,
    required this.orden,
    required this.texto,
    required this.tipo,
    required this.obligatoria,
    this.opciones = const [],
  });

  final String id;
  final int orden;
  final String texto;
  final TipoPregunta tipo;
  final bool obligatoria;
  final List<OpcionPregunta> opciones;

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id: json['id'] as String,
      orden: json['orden'] as int,
      texto: json['texto'] as String,
      tipo: _tipoDesdeJson(json['tipo'] as String),
      obligatoria: json['obligatoria'] as bool? ?? false,
      opciones: (json['opciones'] as List<dynamic>? ?? [])
          .map((e) => OpcionPregunta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
