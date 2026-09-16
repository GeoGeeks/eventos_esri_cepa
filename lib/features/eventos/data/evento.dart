import '../../../core/constants/images.dart';

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
  });

  final String id;
  final String nombre;
  final String? descripcion;
  final DateTime fechaInicio;
  final DateTime fechaFinalizacion;
  final String? lugar;
  final String? urlEvento;

  /// Portada subida por un admin - null hasta que alguien la suba (ver
  /// `EventosExtensionAdminController.subirImagen`). Las tarjetas deben
  /// tener un asset de respaldo para este caso, no asumir que siempre viene.
  final String? imagenUrl;

  /// `eventosdb.Evento` solo trae fecha, sin hora - estos dos son la
  /// extensión local, también opcionales: quedan `null` hasta que un admin
  /// le ponga hora al evento.
  final DateTime? horaInicio;
  final DateTime? horaFin;

  /// Lo que las tarjetas deben usar como `image` - la portada real si ya la
  /// subieron, o el asset generico mientras tanto (nunca un `image` vacio).
  String get imagenParaCarta => imagenUrl ?? Images.esriEventos;

  /// `true` si el evento ya terminó (compara contra la fecha de HOY, no la
  /// hora exacta - un evento que termina hoy sigue contando como vigente
  /// todo el día). `EventosStore` lo usa para no mostrar un evento ya
  /// pasado ni en "Eventos reservados" ni en "Próximos eventos".
  bool get yaPaso {
    final hoy = DateTime.now();
    final finDelDia = DateTime(
      fechaFinalizacion.year,
      fechaFinalizacion.month,
      fechaFinalizacion.day,
      23,
      59,
      59,
    );
    return finDelDia.isBefore(hoy);
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
      horaInicio: _parsearFechaOpcional(json['horaInicio']),
      horaFin: _parsearFechaOpcional(json['horaFin']),
    );
  }

  static DateTime? _parsearFechaOpcional(Object? valor) =>
      valor == null ? null : DateTime.parse(valor as String);

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
}
