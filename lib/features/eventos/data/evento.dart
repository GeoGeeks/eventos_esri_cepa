import '../../../core/constants/images.dart';
import '../../../core/utils/hora_evento.dart';

/// Evento real, tal como lo devuelve `GET /eventos` de `eventos_esri_cepa_api`
/// (fusión de `eventosdb.Evento` con la extensión local `EventoExtension` -
/// ver el `CLAUDE.md` de ese repo, "Evento - extension local"). Reemplaza el
/// mock `ProximoEvento`.
class Evento {
  const Evento({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.fechaInicio,
    required this.fechaFinalizacion,
    this.lugar,
    this.urlEvento,
    this.imagenUrl,
    this.horaInicio,
    this.horaFin,
    this.postEventoHabilitadoDesde,
    this.modulosHabilitados = const [],
    this.horarioTexto,
    this.finalizadoSegunApi,
    this.postEventoAbiertoSegunApi,
  });

  final String id;
  final String nombre;
  final String? descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinalizacion;
  final String? lugar;
  final String? urlEvento;

  /// Módulos DINÁMICOS encendidos para este evento desde Admin
  /// (`EventoExtension.modulosHabilitados` en `eventos_esri_cepa_api`) -
  /// valores posibles: 'laboratorios'/'speakers'/'experiencias'/'stands'/
  /// 'agendamientos'/'encuestas'. Los 5 módulos "obligatorios" (Agenda,
  /// Notificaciones, Usuarios, Galería, la encuesta `post_evento`) no
  /// viven aquí - siempre están encendidos. Vacío mientras Admin no lo
  /// configure - `InvitadosScreen` trata eso como "ningún dinámico con
  /// pestaña habilitado", no como "todavía no se sabe" (ver
  /// `tieneAlgunModuloConPestana`).
  final List<String> modulosHabilitados;

  bool get tieneLaboratorios => modulosHabilitados.contains('laboratorios');
  bool get tieneSpeakers => modulosHabilitados.contains('speakers');
  bool get tieneExperiencias => modulosHabilitados.contains('experiencias');
  bool get tieneStands => modulosHabilitados.contains('stands');

  /// Pestaña "Encuestas" (2026-09-22) - solo las encuestas `tipo: 'modulo'`
  /// dentro del evento, NO la `post_evento` (esa sigue sin interruptor, ver
  /// el comentario de arriba).
  bool get tieneEncuestas => modulosHabilitados.contains('encuestas');

  /// Los módulos dinámicos que traen su propia pestaña en `InvitadosScreen`
  /// (Agendamientos es el 5º dinámico, pero no tiene pestaña ahí - es la
  /// `FormularioWebModal` de "agendar con expertos"). Si ninguno está
  /// encendido, Agenda deja de tener botón propio y pasa a mostrarse
  /// embebida como una pestaña más.
  bool get tieneAlgunModuloConPestana =>
      tieneLaboratorios ||
      tieneSpeakers ||
      tieneExperiencias ||
      tieneStands ||
      tieneEncuestas;

  /// Portada subida por un admin - null hasta que alguien la suba (ver
  /// `EventosExtensionAdminController.subirImagen`). Las tarjetas deben
  /// tener un asset de respaldo para este caso, no asumir que siempre viene.
  final String? imagenUrl;

  /// `eventosdb.Evento` solo trae fecha, sin hora - estos dos son la
  /// extensión local, también opcionales: quedan `null` hasta que un admin
  /// le ponga hora al evento. Son horas de AGENDA (ver
  /// `core/utils/hora_evento.dart`): los dígitos son la hora del evento y se
  /// pintan tal cual, sin pasar por la zona horaria del teléfono.
  final DateTime? horaInicio;
  final DateTime? horaFin;

  /// Decisiones que ya manda la API (`horarioTexto`, `finalizado`,
  /// `postEventoAbierto` en `GET /eventos`): si llegan, mandan sobre el
  /// cálculo local, así una regla se corrige sin publicar la app. `null`
  /// si la API desplegada todavía no las envía.
  final String? horarioTexto;
  final bool? finalizadoSegunApi;
  final bool? postEventoAbiertoSegunApi;

  /// Desde cuándo está abierto el post-evento (galería, certificado) - `null`
  /// = cerrado; no se abre solo al terminar el evento (ver la extensión de
  /// Evento en `eventos_esri_cepa_api`).
  final DateTime? postEventoHabilitadoDesde;

  /// Misma regla que el backend (`postEventoAbierto`): hay fecha y ya pasó.
  /// `postEventoHabilitadoDesde` es un instante real, así que aquí sí se
  /// compara con `DateTime.now()`.
  bool get postEventoAbierto {
    final segunApi = postEventoAbiertoSegunApi;
    if (segunApi != null) return segunApi;
    final desde = postEventoHabilitadoDesde;
    return desde != null && !desde.isAfter(DateTime.now());
  }

  /// Lo que las tarjetas deben usar como `image` - la portada real si ya la
  /// subieron, o el asset generico mientras tanto (nunca un `image` vacio).
  String get imagenParaCarta => imagenUrl ?? Images.esriEventos;

  /// `true` si el evento ya terminó. `EventosStore` lo usa para no mostrar
  /// un evento ya pasado ni en "Eventos reservados" ni en "Próximos
  /// eventos" (y sí en "Eventos asistidos").
  ///
  /// Termina al final del día de `fechaFinalizacion` - un evento que
  /// termina hoy sigue vigente todo el día - o en `horaFin`, lo que sea
  /// MÁS TARDE: `eventosdb` a veces trae `FechaFinalizacion` = día de
  /// inicio en un evento de varios días (CUE_26_CO: 1 y 2 de octubre, con
  /// `FechaFinalizacion` 2026-10-01), y `horaFin` es la corrección que se
  /// hace desde nuestra propia API sin tocar `eventosdb`.
  ///
  /// Manda `finalizado` de la API; el cálculo local es el respaldo y se hace
  /// en hora del evento (`horaFin` es hora de agenda).
  bool get yaPaso {
    final segunApi = finalizadoSegunApi;
    if (segunApi != null) return segunApi;
    var fin = DateTime.utc(
      fechaFinalizacion.year,
      fechaFinalizacion.month,
      fechaFinalizacion.day,
      23,
      59,
      59,
    );
    final horaFin = this.horaFin;
    if (horaFin != null && horaFin.isAfter(fin)) fin = horaFin;
    return fin.isBefore(ahoraEnHoraDelEvento());
  }

  /// ⚠️ Sin fuente de dato real todavia: `eventosdb.Evento.IDTipoEvento` es
  /// un codigo de TIPO de evento ("CUE", "PE"), no de modalidad - medido
  /// contra la respuesta real, ningun evento activo hoy trae un campo que
  /// distinga presencial/virtual. Todos los eventos reales de hoy tienen
  /// `Lugar` (dirección física) diligenciado, así que se infiere `true`
  /// mientras no exista un campo real - no inventar un valor más específico
  /// que eso.
  bool get presencial => true;

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['IDEvento'] as String,
      nombre: json['Nombre'] as String,
      descripcion: json['Descripcion'] as String?,
      fechaInicio: DateTime.parse(json['FechaInicio'] as String),
      fechaFinalizacion: DateTime.parse(json['FechaFinalizacion'] as String),
      lugar: json['Lugar'] as String?,
      urlEvento: json['UrlEvento'] as String?,
      imagenUrl: json['imagenUrl'] as String?,
      horaInicio: _parsearHoraDeAgenda(json['horaInicio']),
      horaFin: _parsearHoraDeAgenda(json['horaFin']),
      postEventoHabilitadoDesde: _parsearFechaOpcional(
        json['postEventoHabilitadoDesde'],
      ),
      modulosHabilitados: (json['modulosHabilitados'] as List<dynamic>? ?? [])
          .cast<String>(),
      horarioTexto: json['horarioTexto'] as String?,
      finalizadoSegunApi: json['finalizado'] as bool?,
      postEventoAbiertoSegunApi: json['postEventoAbierto'] as bool?,
    );
  }

  /// Hora de agenda: se conservan los dígitos (ver `leerHoraDeAgenda`).
  /// Antes pasaba por `toLocal()` y el CUE (07:00Z = 7:00 a.m.) se veía a
  /// las 2:00.
  static DateTime? _parsearHoraDeAgenda(Object? valor) =>
      valor == null ? null : leerHoraDeAgenda(valor as String);

  /// Instantes reales (`postEventoHabilitadoDesde`): `.toLocal()` los pasa a
  /// la hora del dispositivo. No usar para horas de agenda (ver
  /// `_parsearHoraDeAgenda`).
  static DateTime? _parsearFechaOpcional(Object? valor) =>
      valor == null ? null : DateTime.parse(valor as String).toLocal();

  static const List<String> _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  /// "Septiembre 10" - mismo formato que ya escribían los mocks (la
  /// abreviatura a "Sept" la aplican las propias tarjetas, ver
  /// `FormatoFecha.mesCorto`, no los datos).
  String get fechaFormateada =>
      '${_meses[fechaInicio.month - 1]} ${fechaInicio.day}';

  /// "08:00 a.m." - null si el admin todavia no le puso hora al evento (ver
  /// `horaInicio`). Los llamadores deben mostrar solo la fecha en ese caso,
  /// no inventar una hora.
  String? get horaFormateada {
    final hora = horaInicio;
    if (hora == null) return null;
    final h = hora.hour;
    final esPm = h >= 12;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final m = hora.minute.toString().padLeft(2, '0');
    return '$h12:$m ${esPm ? 'p.m.' : 'a.m.'}';
  }

  /// "Septiembre 10 - 08:00 a.m." si hay hora, o solo "Septiembre 10" si no
  /// - lo que las tarjetas (`EventCard`/`UpcomingEventCard`) esperan como
  /// `date` ya compuesto.
  String get fechaYHoraFormateada {
    final hora = horaFormateada;
    return hora == null ? fechaFormateada : '$fechaFormateada - $hora';
  }

  /// "Octubre 01, 2026" para un solo día, o "Octubre 01 y 02, 2026" /
  /// "Octubre 01 - Noviembre 02, 2026" cuando `fechaFinalizacion` es
  /// distinta. Si `horaFin` cae en un día posterior a `fechaFinalizacion`
  /// (ver `yaPaso`), el rango llega hasta ese día.
  String get rangoFechasFormateado {
    final inicio = fechaInicio;
    var fin = fechaFinalizacion;
    final horaFin = this.horaFin;
    if (horaFin != null &&
        DateTime(horaFin.year, horaFin.month, horaFin.day).isAfter(fin)) {
      fin = horaFin;
    }
    final mesInicio = _meses[inicio.month - 1];
    final d1 = inicio.day.toString().padLeft(2, '0');
    if (inicio.year == fin.year &&
        inicio.month == fin.month &&
        inicio.day == fin.day) {
      return '$mesInicio $d1, ${inicio.year}';
    }
    final d2 = fin.day.toString().padLeft(2, '0');
    if (inicio.year == fin.year && inicio.month == fin.month) {
      return '$mesInicio $d1 y $d2, ${inicio.year}';
    }
    final mesFin = _meses[fin.month - 1];
    return '$mesInicio $d1 - $mesFin $d2, ${fin.year}';
  }

  /// "8:00 - 17:00", solo la de inicio si no hay `horaFin`, o vacío si el
  /// evento todavía no tiene hora asignada.
  String get rangoHorasFormateado {
    final segunApi = horarioTexto;
    if (segunApi != null) return segunApi;
    final inicio = horaInicio;
    if (inicio == null) return '';
    final h1 = '${inicio.hour}:${inicio.minute.toString().padLeft(2, '0')}';
    final fin = horaFin;
    if (fin == null) return h1;
    final h2 = '${fin.hour}:${fin.minute.toString().padLeft(2, '0')}';
    return '$h1 - $h2';
  }
}
