import 'catalogo_item.dart';

/// Laboratorio (taller práctico) de un evento, tal como lo devuelve
/// `eventos_esri_cepa_api` (`GET /eventos/:idEvento/laboratorios`) - ver la
/// entidad `Laboratorio` de ese repo.
///
/// ⚠️ Sin `ponente`: igual que `Charla`, el backend no trae ese campo - ver
/// el comentario de esa clase.
class Laboratorio {
  const Laboratorio({
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
    this.cupo,
    this.objetivos = const [],
    this.tematicas = const [],
    this.productosEsri = const [],
    this.publicosObjetivo = const [],
    this.nivelesSesion = const [],
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

  /// Tope propio de esta sesión - `null` = sin límite propio (sigue sujeto
  /// al cupo de franja compartido, que el backend no expone todavía como
  /// "cupos restantes"; ver `RegistroLaboratorioRepository`).
  final int? cupo;
  final List<String> objetivos;
  final List<CatalogoItem> tematicas;
  final List<CatalogoItem> productosEsri;
  final List<CatalogoItem> publicosObjetivo;
  final List<CatalogoItem> nivelesSesion;

  /// "Oct 02 - 11:00 a.m." - mismo formato que ya usaban las tarjetas de
  /// sesión (`SesionEvento.fecha`, con hora incluida).
  String get fechaYHoraFormateada {
    const meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    final h = horaInicio.hour;
    final esPm = h >= 12;
    final h12 = h % 12 == 0 ? 12 : h % 12;
    final m = horaInicio.minute.toString().padLeft(2, '0');
    return '${meses[fecha.month - 1]} ${fecha.day.toString().padLeft(2, '0')} - '
        '$h12:$m ${esPm ? 'p.m.' : 'a.m.'}';
  }

  List<String> get etiquetas => [
        ...tematicas.map((t) => t.valor),
        ...productosEsri.map((p) => p.valor),
        ...nivelesSesion.map((n) => n.valor),
      ];

  factory Laboratorio.fromJson(Map<String, dynamic> json) {
    List<CatalogoItem> catalogo(String clave) =>
        (json[clave] as List<dynamic>?)
                ?.map((e) => CatalogoItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [];
    return Laboratorio(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String?,
      dia: json['dia'] as String?,
      fecha: DateTime.parse(json['fecha'] as String),
      horaInicio: DateTime.parse(json['horaInicio'] as String),
      horaFin: DateTime.parse(json['horaFin'] as String),
      tipoActividad: json['tipoActividad'] as String?,
      lugar: json['lugar'] as String?,
      cupo: json['cupo'] as int?,
      objetivos: (json['objetivos'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>)['objetivo'] as String)
              .toList() ??
          const [],
      tematicas: catalogo('tematicas'),
      productosEsri: catalogo('productosEsri'),
      publicosObjetivo: catalogo('publicosObjetivo'),
      nivelesSesion: catalogo('nivelesSesion'),
    );
  }
}
