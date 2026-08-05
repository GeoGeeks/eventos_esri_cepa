/// Estado del cupo de un laboratorio. Decide qué botón muestra la tarjeta.
enum EstadoCupo {
  /// Quedan cupos: botón «Reservar cupo» azul con el signo «+».
  disponible,

  /// El usuario ya reservó: botón «Cancelar reserva» con borde rojo.
  reservado,

  /// No quedan cupos: aviso en gris y botón «Reservar cupos» apagado.
  agotado,
}

/// Días y horarios que ofrece el formulario de reserva.
///
/// Están quemados a la espera del backend; salen de
/// `assets/views/Laboratorios_reserva.svg` y `assets/views/filtro-horarios.svg`.
class LaboratorioData {
  LaboratorioData._();

  static const List<String> dias = [
    'Día 1 | Octubre 01',
    'Día 2 | Octubre 02',
  ];

  static const List<String> horarios = [
    '8:00 m. a 9:00 a.m.',
    '9:00 a.m. a 10:00 a.m.',
    '10:00 a.m. a 11:00 a.m.',
    '11:00 a.m. a 12:00 m.',
    '12:00 m. a 1:00 p.m.',
    '1:00 p.m. a 2:00 p.m.',
    '2:00 p.m. a 3:00 p.m.',
    '3:00 p.m. a 4:00 p.m.',
    '4:00 p.m. a 5:00 p.m.',
  ];

  static const String avisoHorario =
      'Debe presentarse 15 minutos antes al salón EFG y su cupo será '
      'reservado hasta pasados 5 minutos.';

  static const String avisoAgotado =
      'Los cupos de pre-registro están completos, lo invitamos a acercarse en '
      'el evento para registrarse al laboratorio.';
}
