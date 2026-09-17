import '../../agenda/data/franja_horaria.dart';

/// Lo que devuelve `ReservaCupoModal.mostrar()` en modo real: el día +
/// franja que el asistente eligió, listos para mandar a
/// `POST /registros-laboratorio` (`fecha` + `franjaHorariaId`).
class SeleccionReserva {
  const SeleccionReserva({
    required this.fechaComoDateTime,
    required this.franja,
  });

  final DateTime fechaComoDateTime;
  final FranjaHoraria franja;

  /// "2026-10-01" - lo que espera el backend en `CrearRegistroLaboratorioDto.fecha`.
  String get fecha {
    final anio = fechaComoDateTime.year.toString().padLeft(4, '0');
    final mes = fechaComoDateTime.month.toString().padLeft(2, '0');
    final dia = fechaComoDateTime.day.toString().padLeft(2, '0');
    return '$anio-$mes-$dia';
  }

  String get franjaHorariaId => franja.id;

  /// Sentinel para el modo mock (sin franjas reales que elegir) - el
  /// llamador nunca inspecciona sus campos, solo comprueba que no sea `null`.
  factory SeleccionReserva.mock() => SeleccionReserva(
        fechaComoDateTime: DateTime(0),
        franja: const FranjaHoraria(id: 'mock', horaInicio: '00:00', horaFin: '00:00'),
      );
}
