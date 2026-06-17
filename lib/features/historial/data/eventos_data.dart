import '../../../core/constants/images.dart';

class Evento {
  final String titulo;
  final String fecha;
  final String hora;
  final String direccion;
  final bool presencial;
  final String image;
  final String mes;

  Evento({
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.presencial,
    required this.image,
    required this.mes,
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
    mes: 'Junio',
  ),

  Evento(
    titulo: 'Planeta Esri',
    fecha: '02 Oct 2026',
    hora: '11:00 a.m.',
    direccion: 'Calle 32 # 54 - 34',
    presencial: true,
    image: Images.planetaEsri,
    mes: 'Agosto',
  ),

  Evento(
    titulo: 'Planeta Esri',
    fecha: '02 Oct 2026',
    hora: '11:00 a.m.',
    direccion: 'Calle 32 # 54 - 34',
    presencial: true,
    image: Images.planetaEsri,
    mes: 'Agosto',
  ),
];