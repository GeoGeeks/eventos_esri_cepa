import 'catalogo_item.dart';
import 'disponibilidad_dia.dart';
import 'franja_horaria.dart';

/// Laboratorio (taller práctico) de un evento, tal como lo devuelve
/// `eventos_esri_cepa_api` (`GET /eventos/:idEvento/laboratorios`) - ver la
/// entidad `Laboratorio` de ese repo.
///
/// Es solo CONTENIDO - no tiene fecha/hora propia (a diferencia de
/// `Charla`): un mismo laboratorio puede ofrecerse en varios días
/// distintos, cada uno con sus propias franjas (ver `disponibilidad`).
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
    this.tipoActividad,
    this.lugar,
    this.cupo,
    this.objetivos = const [],
    this.tematicas = const [],
    this.productosEsri = const [],
    this.publicosObjetivo = const [],
    this.nivelesSesion = const [],
    this.disponibilidad = const [],
  });

  final String id;
  final String idEvento;
  final String nombre;
  final String? descripcion;
  final String? dia;
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

  /// Los días en los que se puede tomar este laboratorio, cada uno con sus
  /// franjas reales - vacío = todavía sin disponibilidad configurada en
  /// Admin. El asistente elige UN día + UNA franja al reservar.
  final List<DisponibilidadDia> disponibilidad;

  /// "Oct 01" (un solo día) u "Oct 01 y Oct 02" (varios) - resumen para la
  /// cabecera de la tarjeta. La franja concreta reservada (si aplica) se
  /// muestra aparte, ver `SesionEvento.reservaFormateada`.
  String get resumenDias {
    if (disponibilidad.isEmpty) return '';
    const meses = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
    ];
    String formato(DateTime f) =>
        '${meses[f.month - 1]} ${f.day.toString().padLeft(2, '0')}';
    return disponibilidad.map((d) => formato(d.fecha)).join(' y ');
  }

  /// Ver el doc-comment equivalente en `Charla.etiquetas` (mismo criterio,
  /// descarta cualquier `valor` vacío).
  List<String> get etiquetas => [
        ...tematicas.map((t) => t.valor),
        ...productosEsri.map((p) => p.valor),
        ...nivelesSesion.map((n) => n.valor),
      ].where((valor) => valor.trim().isNotEmpty).toList();

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
      disponibilidad: _disponibilidadDesdeJson(json['disponibilidad']),
    );
  }

  /// El backend manda una lista PLANA de filas `{fecha, franjaHoraria}` (una
  /// por combinación día+franja) - se agrupan aquí por día, en el orden en
  /// que aparecen.
  static List<DisponibilidadDia> _disponibilidadDesdeJson(dynamic json) {
    final items = (json as List<dynamic>?) ?? const [];
    final porFecha = <String, List<FranjaHoraria>>{};
    for (final item in items) {
      final mapa = item as Map<String, dynamic>;
      final fecha = (mapa['fecha'] as String).substring(0, 10);
      final franja =
          FranjaHoraria.fromJson(mapa['franjaHoraria'] as Map<String, dynamic>);
      (porFecha[fecha] ??= []).add(franja);
    }
    final dias = porFecha.entries
        .map((e) => DisponibilidadDia(fecha: DateTime.parse(e.key), franjas: e.value))
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
    return dias;
  }
}
