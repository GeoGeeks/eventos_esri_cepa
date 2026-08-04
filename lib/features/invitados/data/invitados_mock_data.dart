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

  const PersonaEvento({
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
  });
}

class SesionEvento {
  final String titulo;
  final String fecha;
  final String lugar;
  final bool favorita;

  const SesionEvento({
    required this.titulo,
    required this.fecha,
    required this.lugar,
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

  static const List<PersonaEvento> speakers = [
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: _descripcionSesion,
    ),
  ];

  static const List<PersonaEvento> experiencias = [
    PersonaEvento(
      imagenAsset: Images.experienciaComunidad,
      titulo: 'Comunidad',
      subtitulo: 'comunidad@esri.co',
      descripcion: _descripcionSesion,
    ),
    PersonaEvento(
      imagenAsset: Images.experienciaGeoIA,
      titulo: 'GeoIA',
      subtitulo: 'geoia@esri.co',
      descripcion: _descripcionSesion,
    ),
  ];

  static const List<SesionEvento> stands = [
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
  ];

  static const List<SesionEvento> laboratorios = [
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
  ];
}
