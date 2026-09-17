/// Un valor de catálogo de Agenda (Temática, Producto Esri, Público
/// objetivo o Nivel de sesión), tal como lo devuelve `GET /catalogos-agenda`
/// y como viaja embebido en `Charla`/`Laboratorio` (relaciones
/// muchos-a-muchos). Las cuatro tablas del backend comparten esta misma
/// forma (`id`, `valor`, `valorNormalizado`), así que un solo modelo Dart
/// alcanza para las cuatro.
class CatalogoItem {
  const CatalogoItem({
    required this.id,
    required this.valor,
    required this.valorNormalizado,
  });

  final int id;
  final String valor;
  final String valorNormalizado;

  factory CatalogoItem.fromJson(Map<String, dynamic> json) {
    return CatalogoItem(
      id: json['id'] as int,
      valor: json['valor'] as String,
      valorNormalizado: json['valorNormalizado'] as String,
    );
  }
}

/// Los cuatro catálogos juntos - forma exacta de `GET /catalogos-agenda`
/// (`AgendaLookupResolverService.listarCatalogos` en el backend).
class CatalogosAgenda {
  const CatalogosAgenda({
    required this.tematicas,
    required this.productosEsri,
    required this.publicosObjetivo,
    required this.nivelesSesion,
  });

  final List<CatalogoItem> tematicas;
  final List<CatalogoItem> productosEsri;
  final List<CatalogoItem> publicosObjetivo;
  final List<CatalogoItem> nivelesSesion;

  static const CatalogosAgenda vacio = CatalogosAgenda(
    tematicas: [],
    productosEsri: [],
    publicosObjetivo: [],
    nivelesSesion: [],
  );

  factory CatalogosAgenda.fromJson(Map<String, dynamic> json) {
    List<CatalogoItem> lista(String clave) => (json[clave] as List<dynamic>?)
            ?.map((e) => CatalogoItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [];
    return CatalogosAgenda(
      tematicas: lista('tematicas'),
      productosEsri: lista('productosEsri'),
      publicosObjetivo: lista('publicosObjetivo'),
      nivelesSesion: lista('nivelesSesion'),
    );
  }
}
