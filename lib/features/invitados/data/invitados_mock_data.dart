import '../../../core/constants/images.dart';
import '../../laboratorios/data/laboratorio_data.dart';

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

/// Persona de la pestaña **Speakers e Invitados**.
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

/// Tarjeta de **Experiencias** y **Stands**. La diferencia entre las dos es
/// que Stands lleva subtítulo («Partner Member»); el resto es idéntico.
class ExperienciaEvento {
  final String imagenAsset;
  final String titulo;
  final String? subtitulo;
  final String fecha;
  final String lugar;

  /// Solo visibles al desplegar la tarjeta.
  final String descripcion;
  final String enlace;

  const ExperienciaEvento({
    required this.imagenAsset,
    required this.titulo,
    required this.fecha,
    required this.lugar,
    required this.descripcion,
    required this.enlace,
    this.subtitulo,
  });
}

/// Sesión de **Laboratorios**.
class SesionEvento {
  final String titulo;
  final String fecha;
  final String lugar;

  /// Datos que la tarjeta de Laboratorios no pinta pero sí necesita la de
  /// Favoritos cuando la sesión se marca con la estrella.
  final String ponente;
  final String aforo;

  final List<String> etiquetas;
  final String descripcion;
  final String tituloObjetivos;
  final List<String> objetivos;
  final bool favorita;

  /// Estado inicial del cupo. La pantalla lo va cambiando según reserve o
  /// cancele el usuario; cuando entre el backend será el valor que él mande.
  final EstadoCupo estadoCupo;

  const SesionEvento({
    required this.titulo,
    required this.fecha,
    required this.lugar,
    this.ponente = '',
    this.aforo = '',
    this.etiquetas = const [],
    this.descripcion = '',
    this.tituloObjetivos = 'Objetivos',
    this.objetivos = const [],
    this.favorita = false,
    this.estadoCupo = EstadoCupo.disponible,
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

  /// Una sola tarjeta, como el diseño. Cuando los datos lleguen del backend
  /// esta lista se sustituye sin tocar la pantalla ni `InfoCard`.
  static const List<PersonaEvento> speakers = [
    PersonaEvento(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Ismael Chivite',
      subtitulo: 'Product manager',
      descripcion: 'Con más de 20 años dedicados al mundo de los Sistemas de '
          'Información Geográfica.',
      fecha: _fechaSesion,
      lugar: _lugarSesion,
    ),
  ];

  static const List<ExperienciaEvento> experiencias = [
    ExperienciaEvento(
      imagenAsset: Images.experienciaComunidad,
      titulo: 'Comunidad Esri',
      fecha: 'Oct 01 y 02 – 11:00 a.m.',
      lugar: 'Piso 2',
      descripcion: 'La Comunidad Esri te espera en nuestro stand\n\n'
          'Descubre tu ruta en SIG, inspírate con proyectos reales, vive '
          'conversaciones únicas y llévate recuerdos memorables.',
      enlace: 'cgarnica@esri.co',
    ),
  ];

  static const List<ExperienciaEvento> stands = [
    ExperienciaEvento(
      imagenAsset: Images.fotoInvitado2,
      titulo: 'Gentemovil',
      subtitulo: 'Partner Member',
      fecha: 'Oct 01 y 02 – 11:00 a.m.',
      lugar: 'Piso 2',
      descripcion:
          'Expertos en soluciones GIS. CatasIA es su plataforma para Catastro '
          'Multipropósito, basada en LADM-COL y ArcGIS, que mejora la gestión '
          'catastral con tecnología confiable y escalable.',
      enlace: 'jangel@gentemovil.co',
    ),
  ];

  static const List<SesionEvento> laboratorios = [
    SesionEvento(
      titulo: _descripcionSesion,
      fecha: _fechaSesion,
      lugar: 'Auditorio 103',
      ponente: 'Julian Gutiérrez',
      aforo: 'Aforo 30 personas',
      etiquetas: _etiquetas,
      descripcion: _detalleSesion,
      objetivos: _objetivos,
    ),
  ];
}
