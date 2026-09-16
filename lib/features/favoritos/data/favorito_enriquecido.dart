import '../../agenda/data/charla.dart';
import '../../agenda/data/laboratorio.dart';

/// Un favorito del asistente logueado, con la Charla o el Laboratorio
/// completo ya cargado - tal como lo devuelve `GET /favoritos` de
/// `eventos_esri_cepa_api` (`FavoritoEnriquecido` en ese repo).
///
/// `tipo` dice cuál de los dos campos ([charla]/[laboratorio]) viene lleno -
/// el otro siempre es `null`. Modelado así (dos campos nullable) en vez de
/// un tipo unión porque Dart no tiene uno nativo cómodo para esto y el
/// dominio real solo tiene dos casos posibles.
class FavoritoEnriquecido {
  const FavoritoEnriquecido({
    required this.id,
    required this.tipo,
    required this.createdAt,
    this.charla,
    this.laboratorio,
  });

  final String id;

  /// `'charla'` | `'laboratorio'` - ver `TipoFavorito` en el backend.
  final String tipo;
  final DateTime createdAt;
  final Charla? charla;
  final Laboratorio? laboratorio;

  /// El id de la actividad favorita en sí (charla o laboratorio, según
  /// [tipo]) - lo que hace falta para `DELETE /favoritos/:itemId`.
  String get itemId => charla?.id ?? laboratorio!.id;

  factory FavoritoEnriquecido.fromJson(Map<String, dynamic> json) {
    final tipo = json['tipo'] as String;
    final actividad = json['actividad'] as Map<String, dynamic>;
    return FavoritoEnriquecido(
      id: json['id'] as String,
      tipo: tipo,
      createdAt: DateTime.parse(json['createdAt'] as String),
      charla: tipo == 'charla' ? Charla.fromJson(actividad) : null,
      laboratorio: tipo == 'laboratorio'
          ? Laboratorio.fromJson(actividad)
          : null,
    );
  }
}
