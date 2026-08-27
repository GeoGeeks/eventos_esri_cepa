import '../../../core/constants/images.dart';

class Evento {
  final String titulo;
  final String fecha;
  final String hora;
  final String direccion;
  final bool presencial;
  final String image;
  final String estado;

  Evento({
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.presencial,
    required this.image,
    required this.estado,
  });
}

final eventosMock = [
  Evento(
    titulo: 'Planeta Esri',
    fecha: 'Agosto 15',
    hora: '10:00 a.m.',
    direccion: 'Calle 32 # 54-34',
    presencial: true,
    image: Images.planetaEsri,
    estado: 'Finalizado',
  ),
  Evento(
    titulo: 'Planeta Esri',
    fecha: 'Septiembre 10',
    hora: '09:00 a.m.',
    direccion: 'Calle 32 # 54-34',
    presencial: true,
    image: Images.planetaEsri,
    estado: 'Finalizado',
  ),
];
