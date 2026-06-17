import '../../../core/constants/images.dart';

class Evento {
  final String titulo;
  final String fecha;
  final String hora;
  final String direccion;
  final bool presencial;
  final String image;

  Evento({
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.presencial,
    required this.image,
  });
}

final eventosMock = [
  Evento(
    titulo: 'Planeta Esri Bogotá',
    fecha: '23 Mayo 2026',
    hora: '08:00 AM',
    direccion: 'Universidad Central',
    presencial: true,
    image: Images.planetaEsri,
  ),
  Evento(
    titulo: 'ArcGIS Webinar',
    fecha: '12 Junio 2026',
    hora: '09:00 AM',
    direccion: 'Virtual',
    presencial: false,
    image: Images.esriEventos,
  ),
];