class GrupoFiltro {
  final String etiqueta;
  final String titulo;
  final List<String> opciones;

  const GrupoFiltro({
    required this.etiqueta,
    required this.titulo,
    required this.opciones,
  });
}

class FiltroData {
  FiltroData._();

  static const List<GrupoFiltro> grupos = [
    GrupoFiltro(
      etiqueta: 'Lugar',
      titulo: 'Lugar',
      opciones: [
        'Auditorio 103',
        'Auditorio 201',
        'Sala de laboratorios',
        'Zona de stands',
      ],
    ),
    GrupoFiltro(
      etiqueta: 'Actividad',
      titulo: 'Tipo de Actividad',
      opciones: ['Conferencia', 'Laboratorio', 'Stand', 'Experiencia'],
    ),
    GrupoFiltro(
      etiqueta: 'Temática',
      titulo: 'Temática',
      opciones: [
        'Tecnología',
        'GeoIA',
        'Educación',
        'Gobierno',
        'Sostenibilidad',
      ],
    ),
    GrupoFiltro(
      etiqueta: 'Nivel',
      titulo: 'Nivel',
      opciones: ['Básico', 'Intermedio', 'Avanzado', 'Todos los niveles'],
    ),
    GrupoFiltro(
      etiqueta: 'Producto',
      titulo: 'Producto',
      opciones: [
        'ArcGIS Pro',
        'ArcGIS Online',
        'ArcGIS Survey123',
        'ArcGIS Field Maps',
      ],
    ),
  ];
}
