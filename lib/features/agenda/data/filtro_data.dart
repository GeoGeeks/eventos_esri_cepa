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
    // Primero a propósito (pedido explícito del dueño, 2026-09-21): antes
    // iba al final porque, a diferencia de los otros 5, no tenía posición
    // pixel-verificada contra Figma - eso sigue siendo cierto, pero ya no
    // decide el orden.
    GrupoFiltro(etiqueta: 'Día', titulo: 'Día', opciones: ['Jueves', 'Viernes']),
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
