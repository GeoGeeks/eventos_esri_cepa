class Actividad {
  final String titulo;
  final String horario;
  final String ponente;
  final String lugar;
  final String aforo;
  final List<String> etiquetas;
  final String descripcion;
  final String tituloObjetivos;
  final List<String> objetivos;
  final bool favorita;

  const Actividad({
    required this.titulo,
    required this.horario,
    required this.ponente,
    required this.lugar,
    required this.aforo,
    required this.etiquetas,
    required this.descripcion,
    this.tituloObjetivos = 'Objetivos',
    this.objetivos = const [],
    this.favorita = false,
  });

  Actividad copyWith({bool? favorita}) => Actividad(
    titulo: titulo,
    horario: horario,
    ponente: ponente,
    lugar: lugar,
    aforo: aforo,
    etiquetas: etiquetas,
    descripcion: descripcion,
    tituloObjetivos: tituloObjetivos,
    objetivos: objetivos,
    favorita: favorita ?? this.favorita,
  );
}

class AgendaMockData {
  AgendaMockData._();

  static const String _titulo =
      'Encuestas avanzadas incorporando Inteligencia Artificial en '
      'ArcGIS Survey123';

  static const String _descripcion =
      'Integre modelos de Deep Learning para la detección de objetos en '
      'formularios de Survey123, conozca cómo la IA apoya los flujos de '
      'recolección de información.';

  static const List<String> _objetivos = [
    _descripcion,
    _descripcion,
    _descripcion,
    _descripcion,
  ];

  static const List<Actividad> actividades = [
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
    ),
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
    ),
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
    ),
  ];

  static const List<Actividad> favoritas = [
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
      favorita: true,
    ),
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
      favorita: true,
    ),
    Actividad(
      titulo: _titulo,
      horario: '10:00 - 11:00',
      ponente: 'Julian Gutiérrez',
      lugar: 'Auditorio 103',
      aforo: 'Aforo 30 personas',
      etiquetas: ['Avanzado', 'Tecnología', 'GeoIA'],
      descripcion: _descripcion,
      objetivos: _objetivos,
      favorita: true,
    ),
  ];
}
