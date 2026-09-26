/// Convención de horas de AGENDA, la misma de `eventos_esri_cepa_api`
/// (`src/common/hora-evento.ts`): `horaInicio`/`horaFin` de las charlas y del
/// evento son la hora de pared del lugar del evento, enviadas como si fueran
/// UTC (`08:00Z` = 8:00 a.m. en el evento). Se pintan tal cual, sin
/// `toLocal()`, y se comparan contra [ahoraEnHoraDelEvento], nunca contra
/// `DateTime.now()` directo: si no, se corren 5 horas y dependen de la zona
/// horaria del teléfono.
///
/// No aplica a instantes reales (`postEventoHabilitadoDesde`, fechas de
/// notificaciones), que se comparan con `DateTime.now()`.
///
/// Colombia, Ecuador (continental) y Panamá están en UTC-5 todo el año.
library;

/// Desfase del lugar del evento respecto a UTC.
const Duration desfaseHoraEvento = Duration(hours: -5);

/// "Ahora" en la convención de agenda, para compararlo con horas de agenda.
DateTime ahoraEnHoraDelEvento([DateTime? ahora]) =>
    (ahora ?? DateTime.now()).toUtc().add(desfaseHoraEvento);

final RegExp _fechaHora = RegExp(
  r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?',
);

/// Lee una hora de agenda conservando los dígitos escritos, sin importar la
/// zona que traiga: "10:30-05:00", "10:30Z" y "10:30" quedan todas como las
/// 10:30 del evento (mismo criterio que `leerHoraDeAgenda` en la API).
DateTime leerHoraDeAgenda(String iso) {
  final partes = _fechaHora.firstMatch(iso.trim());
  if (partes == null) return DateTime.parse(iso);
  int parte(int i) => int.parse(partes.group(i) ?? '0');
  return DateTime.utc(
    parte(1),
    parte(2),
    parte(3),
    parte(4),
    parte(5),
    parte(6),
  );
}
