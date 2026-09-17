import '../../agenda/data/laboratorio.dart';

/// La inscripción (preagenda) de un asistente a un laboratorio, tal como la
/// devuelve `eventos_esri_cepa_api` (`GET /registros-laboratorio`) - ver la
/// entidad `RegistroLaboratorio` de ese repo.
class RegistroLaboratorio {
  const RegistroLaboratorio({
    required this.id,
    required this.laboratorioId,
    required this.franjaHorariaId,
    this.laboratorio,
    required this.asistencia,
    required this.createdAt,
  });

  final String id;
  final String laboratorioId;

  /// Cuál de las franjas de ese laboratorio eligió el asistente al registrarse.
  final String franjaHorariaId;

  /// El backend carga el laboratorio completo en `misRegistros()`, pero no
  /// en la respuesta de `POST /registros-laboratorio` - nullable por eso.
  final Laboratorio? laboratorio;
  final String asistencia;
  final DateTime createdAt;

  factory RegistroLaboratorio.fromJson(Map<String, dynamic> json) {
    final laboratorioJson = json['laboratorio'] as Map<String, dynamic>?;
    return RegistroLaboratorio(
      id: json['id'] as String,
      laboratorioId: json['laboratorioId'] as String,
      franjaHorariaId: json['franjaHorariaId'] as String,
      laboratorio: laboratorioJson == null
          ? null
          : Laboratorio.fromJson(laboratorioJson),
      asistencia: json['asistencia'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
