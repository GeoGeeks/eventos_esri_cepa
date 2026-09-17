import 'franja_horaria.dart';

/// Un día en el que se puede tomar un laboratorio, con sus franjas reales
/// - ver `Laboratorio.disponibilidad` y `GET /laboratorios/:id/disponibilidad`
/// en `eventos_esri_cepa_api`. Un mismo laboratorio (un solo contenido)
/// puede tener varios de estos (ej. "Día 1" y "Día 2").
class DisponibilidadDia {
  const DisponibilidadDia({required this.fecha, required this.franjas});

  final DateTime fecha;
  final List<FranjaHoraria> franjas;
}
