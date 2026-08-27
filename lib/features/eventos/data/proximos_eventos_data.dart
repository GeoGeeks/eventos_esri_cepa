import '../../../core/constants/images.dart';

class ProximoEvento {
  final String id;
  final String titulo;
  final String fecha;
  final String hora;
  final String direccion;
  final String image;
  final bool presencial;
  final String descripcion; // <--- Agregado

  const ProximoEvento({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.image,
    required this.presencial,
    required this.descripcion, // <--- Agregado al constructor
  });
}

/// Los dos próximos eventos. De aquí sale el carrusel «Próximos eventos» de
/// Inicio y el listado completo de la pantalla Eventos («Ver todos»), así que
/// las dos pantallas muestran siempre lo mismo.
const List<ProximoEvento> proximosEventosMock = [
  ProximoEvento(
    id: '2',
    titulo: 'Planeta Esri Bogotá',
    fecha: 'Septiembre 10',
    hora: '08:00 a.m.',
    direccion: 'Universidad Central - Teatro de Bogotá',
    image: Images.planetaEsri,
    presencial: true,
    descripcion:
        'Este evento es el espacio ideal para compartir conocimientos, experiencias y soluciones que están marcando la diferencia en la comunidad académica y profesional.',
  ),
  ProximoEvento(
    id: '3',
    titulo: 'CUE 2026',
    fecha: 'Octubre 01',
    hora: '08:00 a.m.',
    direccion: 'Ágora, Bogotá',
    image: Images.esriEventos,
    presencial: true,
    descripcion:
        'Este evento es el espacio ideal para compartir conocimientos, experiencias y soluciones que están marcando la diferencia en la comunidad académica y profesional.',
  ),
];
