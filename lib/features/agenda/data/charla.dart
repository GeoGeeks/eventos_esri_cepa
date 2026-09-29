import '../../../core/utils/hora_evento.dart';
import 'catalogo_item.dart';

/// Charla de un evento, tal como la devuelve `eventos_esri_cepa_api`
/// (`GET /eventos/:idEvento/charlas`, `GET /charlas/:id`) - ver la entidad
/// `Charla` de ese repo.
///
/// ⚠️ Sin `ponente`/`aforo`: la entidad `Charla` del backend no trae esos dos
/// campos (a diferencia de lo que asumía el mock `Actividad` original) - no
/// hay fuente de dato real todavía. `AgendaScreen` los deja vacíos en vez de
/// inventar un valor, mismo criterio que `Evento.presencial` en
/// `features/eventos/data/evento.dart`.
class Charla {
  const Charla({
    required this.id,
    required this.idEvento,
    required this.nombre,
    this.descripcion,
    this.dia,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    this.tipoActividad,
    this.lugar,
    required this.visibilidad,
    this.tematicas = const [],
    this.productosEsri = const [],
    this.publicosObjetivo = const [],
    this.nivelesSesion = const [],
    this.valorable,
  });

  final String id;
  final String idEvento;
  final String nombre;
  final String? descripcion;
  final String? dia;
  final DateTime fecha;
  final DateTime horaInicio;
  final DateTime horaFin;
  final String? tipoActividad;
  final String? lugar;
  final String visibilidad;
  final List<CatalogoItem> tematicas;
  final List<CatalogoItem> productosEsri;
  final List<CatalogoItem> publicosObjetivo;
  final List<CatalogoItem> nivelesSesion;

  /// Si ya se puede valorar, decidido por la API (`valorable`): la charla
  /// terminó en hora del evento. `null` si la API todavía no lo manda
  /// (versión anterior desplegada) - ver `Actividad.mostrarValorar`.
  final bool? valorable;

  /// "10:00 - 11:00" - lo que `ActividadCard.horario` espera ya compuesto.
  String get horarioFormateado =>
      '${_horaCorta(horaInicio)} - ${_horaCorta(horaFin)}';

  /// Temáticas + productos + nivel, aplanados en un solo texto - es lo que
  /// `ActividadCard`/`AgendaScreen._coincideFiltro` esperan como
  /// `etiquetas` (lista plana, sin distinguir de qué catálogo viene cada
  /// una - mismo criterio que ya usaba el mock). Se descarta cualquier
  /// `valor` vacío - `EtiquetaChip` sin texto se pintaba como un círculo
  /// azul vacío en la tarjeta.
  List<String> get etiquetas => [
    ...tematicas.map((t) => t.valor),
    ...productosEsri.map((p) => p.valor),
    ...nivelesSesion.map((n) => n.valor),
  ].where((valor) => valor.trim().isNotEmpty).toList();

  static String _horaCorta(DateTime hora) {
    final h = hora.hour.toString().padLeft(2, '0');
    final m = hora.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  factory Charla.fromJson(Map<String, dynamic> json) {
    List<CatalogoItem> catalogo(String clave) =>
        (json[clave] as List<dynamic>?)
            ?.map((e) => CatalogoItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return Charla(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      dia: json['dia'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
      horaInicio: leerHoraDeAgenda(json['horaInicio'] as String),
      horaFin: leerHoraDeAgenda(json['horaFin'] as String),
      tipoActividad: json['tipoActividad'] as String?,
      lugar: json['lugar'] as String?,
      visibilidad: json['visibilidad'] as String,
      tematicas: catalogo('tematicas'),
      productosEsri: catalogo('productosEsri'),
      publicosObjetivo: catalogo('publicosObjetivo'),
      nivelesSesion: catalogo('nivelesSesion'),
      valorable: json['valorable'] as bool?,
    );
  }
}
