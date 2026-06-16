class Evento {
  final String titulo;
  final String fecha;
  final String hora;
  final String direccion;
  final bool presencial;

  const Evento({
    required this.titulo,
    required this.fecha,
    required this.hora,
    required this.direccion,
    required this.presencial,
  });
}

const List<Evento> eventosMock = [
  Evento(
    titulo: 'Planeta Esri Bogotá',
    fecha: '23 Mayo 2026',
    hora: '08:00 AM',
    direccion: 'Universidad Central',
    presencial: true,
  ),
  Evento(
    titulo: 'ArcGIS Webinar',
    fecha: '12 Junio 2026',
    hora: '09:00 AM',
    direccion: 'Virtual',
    presencial: false,
  ),
];