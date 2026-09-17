/// Un bloque horario reservable de un Laboratorio (ej. "2:00 p.m. a 3:00
/// p.m."), tal como viaja embebido en `Laboratorio.franjasHorarias` - ver
/// `FranjaHoraria` en `eventos_esri_cepa_api`.
///
/// `horaInicio`/`horaFin` llegan como texto "HH:mm" (24 horas, sin fecha) -
/// el laboratorio ya tiene su propia `fecha` fija, la franja solo dice a
/// qué hora dentro de ese día.
class FranjaHoraria {
  const FranjaHoraria({
    required this.id,
    required this.horaInicio,
    required this.horaFin,
  });

  final String id;
  final String horaInicio;
  final String horaFin;

  /// "2:00 p.m. a 3:00 p.m." - formato de 12 horas para mostrar en el selector.
  String get formateada => '${_a12Horas(horaInicio)} a ${_a12Horas(horaFin)}';

  /// Solo la hora de inicio, ej. "2:00 p.m." - para el resumen "Oct 01 - 2:00 p.m." de una reserva ya hecha.
  String get horaInicioFormateada => _a12Horas(horaInicio);

  static String _a12Horas(String hhmm) {
    final partes = hhmm.split(':');
    final hora = int.parse(partes[0]);
    final minuto = partes[1];
    final esPm = hora >= 12;
    final hora12 = hora % 12 == 0 ? 12 : hora % 12;
    return '$hora12:$minuto ${esPm ? 'p.m.' : 'a.m.'}';
  }

  factory FranjaHoraria.fromJson(Map<String, dynamic> json) {
    return FranjaHoraria(
      id: json['id'] as String,
      horaInicio: json['horaInicio'] as String,
      horaFin: json['horaFin'] as String,
    );
  }
}
