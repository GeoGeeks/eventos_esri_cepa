/// Valoración del asistente a una charla ya terminada, tal como la
/// devuelve `eventos_esri_cepa_api` (`POST /valoraciones`,
/// `GET /valoraciones/mis-valoraciones`) - ver la entidad `Valoracion` de
/// ese repo.
class Valoracion {
  const Valoracion({
    required this.id,
    required this.charlaId,
    required this.estrellas,
    this.comentario,
    required this.createdAt,
  });

  final String id;
  final String charlaId;

  /// "¿Qué le pareció?" - 1 a 5.
  final int estrellas;

  /// "Cuéntenos más" - opcional.
  final String? comentario;
  final DateTime createdAt;

  factory Valoracion.fromJson(Map<String, dynamic> json) {
    return Valoracion(
      id: json['id'] as String,
      charlaId: json['charlaId'] as String,
      estrellas: json['estrellas'] as int,
      comentario: json['comentario'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
