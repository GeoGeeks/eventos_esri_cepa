import '../../../core/constants/images.dart';

class EventoDetalle {
  final String fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final String aviso;

  const EventoDetalle({
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.descripcion,
    required this.aviso,
  });
}

class PersonaEvento {
  final String imagenAsset;
  final String titulo;
  final String subtitulo;
  final String descripcion;
  final String fecha;
  final String lugar;

  const PersonaEvento({
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
    required this.fecha,
    required this.lugar,
  });
}

class SesionEvento {
  final String titulo;
  final String fecha;
  final String lugar;
  final List<String> etiquetas;
  final String descripcion;
  final String tituloObjetivos;
  final List<String> objetivos;
  final bool favorita;

  const SesionEvento({
    required this.titulo,
    required this.fecha,
    required this.lugar,
    this.etiquetas = const [],
    this.descripcion = '',
    this.tituloObjetivos = 'Objetivos',
    this.objetivos = const [],
    this.favorita = false,
  });
}

class InvitadosMockData {
  InvitadosMockData._();

  static const EventoDetalle evento = EventoDetalle(
    fecha: 'Octubre 01, 2026',
    hora: '8:00 - 11:00',
    lugar: 'Universidad Central Cra 36 # 24 – 45',
    descripcion:
        'Es un evento presencial gratuito donde podrá conocer historias, '
        'soluciones e innovaciones en el campo de la tecnología y los SIG.',
    aviso: 'Información sujeta a cambios sin aviso.',
  );

  static const String _descripcionSesion =
      'Encuestas avanzadas incorporando Inteligencia Artificial en '
      'ArcGIS Survey123';

  static const String _fechaSesion = 'Oct 02 - 11:00 a.m.';
  static const String _lugarSesion = 'Calle 32 # 54 -34';

  static const List<String> _etiquetas = ['Avanzado', 'Tecnología', 'GeoIA'];

  static const String _detalleSesion =
      'Integre modelos de Deep Learning para la detección de objetos en '
      'formularios de Survey123, conozca cómo la IA apoya los flujos de '
      'recolección de información.';

  static const List<String> _objetivos = [
    _detalleSesion,
    _detalleSesion,
    _detalleSesion,
    _detalleSesion,
  ];

  static const List<PersonaEvento> speakers = [
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
  ];

  static const List<PersonaEvento> experiencias = [
    PersonaEvento(
      imagenAsset: Images.experienciaComunidad,
      titulo: 'Comunidad',
      subtitulo: 'comunidad@esri.co',
      descripcion: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.experienciaGeoIA,
      titulo: 'GeoIA',
      subtitulo: 'geoia@esri.co',
      descripcion: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
  ];

  static const List<SesionEvento> stands = [
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: 'Auditorio 103',
      etiquetas: _etiquetas,
      descripcion: _detalleSesion,
      objetivos: _objetivos,
    ),
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: 'Auditorio 103',
      etiquetas: _etiquetas,
      descripcion: _detalleSesion,
      objetivos: _objetivos,
    ),
  ];

  static const List<SesionEvento> laboratorios = [
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: 'Auditorio 103',
      etiquetas: _etiquetas,
      descripcion: _detalleSesion,
      objetivos: _objetivos,
    ),
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: 'Auditorio 103',
      etiquetas: _etiquetas,
      descripcion: _detalleSesion,
      objetivos: _objetivos,
    ),
  ];
}
