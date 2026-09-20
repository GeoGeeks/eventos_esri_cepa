import '../../agenda/data/charla.dart';

/// Speaker/invitado de un evento, tal como lo devuelve `eventos_esri_cepa_api`
/// (`GET /eventos/:idEvento/speakers`) - ver la entidad `Speaker` de ese
/// repo. `actividades` reutiliza `Charla.fromJson`: el backend devuelve ahí
/// la Charla completa asignada al speaker (mismo shape exacto que
/// `GET /eventos/:idEvento/charlas`), no un resumen aparte.
class Speaker {
  const Speaker({
    required this.id,
    required this.idEvento,
    required this.nombre,
    required this.cargo,
    required this.descripcion,
    this.imagenUrl,
    this.actividades = const [],
  });

  final String id;
  final String idEvento;
  final String nombre;
  final String cargo;
  final String descripcion;
  final String? imagenUrl;

  /// Charlas asignadas ("Asignar charla" en el panel) - vacío si todavía no
  /// se le asignó ninguna. `InvitadosScreen` solo usa la primera para
  /// mostrar "dónde/cuándo" en la tarjeta, igual que hacía el mock.
  final List<Charla> actividades;

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      nombre: json['nombre'] as String,
      cargo: json['cargo'] as String,
      descripcion: json['descripcion'] as String,
      imagenUrl: json['imagenUrl'] as String?,
      actividades: (json['actividades'] as List<dynamic>? ?? [])
          .map((e) => Charla.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
