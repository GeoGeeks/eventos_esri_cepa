import '../../../core/utils/hora_evento.dart';

class Actividad {
  /// Id real de la Charla que esto representa - `null` cuando la actividad
  /// es mock/de prueba. `AgendaScreen`/`FavoritosScreen` lo usan para
  /// llamar al backend real (favoritos); sin él, la pantalla se queda en el
  /// comportamiento local de siempre (ver `AgendaScreen._alternarFavorita`).
  final String? id;
  final String titulo;
  final String horario;
  final String ponente;

  /// Día textual (ej. "Jueves") - vacío en modo mock/de prueba, igual que
  /// `ponente`/`lugar` cuando la Charla real no lo trae. Ver `Charla.dia`.
  final String dia;
  final String lugar;
  final String aforo;
  final List<String> etiquetas;
  final String descripcion;
  final String tituloObjetivos;
  final List<String> objetivos;
  final bool favorita;

  /// Si ya se envió la valoración. Deja de ofrecerse «Valorar».
  final bool valorada;

  /// Hora real de fin de la Charla - `null` en modo mock/de prueba (esas
  /// actividades no tienen un concepto de tiempo real). Junto con [id]
  /// decide si se pinta «Valorar»: ver [mostrarValorar].
  final DateTime? horaFin;

  /// Decisión de la API (`Charla.valorable`); si no llega, se calcula con
  /// [horaFin] - ver [mostrarValorar].
  final bool? valorable;

  const Actividad({
    this.id,
    required this.titulo,
    required this.horario,
    required this.ponente,
    this.dia = '',
    required this.lugar,
    required this.aforo,
    required this.etiquetas,
    required this.descripcion,
    this.tituloObjetivos = 'Objetivos',
    this.objetivos = const [],
    this.favorita = false,
    this.valorada = false,
    this.horaFin,
    this.valorable,
  });

  /// En modo mock (`id == null`) siempre `true` - comportamiento de
  /// siempre, no depende de ninguna hora real. En modo real, «Valorar»
  /// solo se pinta una vez terminada la charla (`horaFin` ya pasó); si la
  /// Charla real no trae `horaFin`, tampoco se pinta - pedido explícito
  /// del usuario, 2026-09-18.
  ///
  /// Manda lo que decida la API (`valorable`), así la regla se corrige sin
  /// publicar la app. Si no llega, se calcula en hora del evento: `horaFin`
  /// es hora de agenda y compararla con `DateTime.now()` habilitaba
  /// «Valorar» 5 horas antes.
  bool get mostrarValorar =>
      id == null ||
      (valorable ??
          (horaFin != null && !ahoraEnHoraDelEvento().isBefore(horaFin!)));

  /// Sin descripción NI objetivos (la Charla real no siempre trae ninguno
  /// de los dos) no hay nada que ver al expandir la tarjeta - `ActividadCard`
  /// oculta la flecha en ese caso. Con al menos uno de los dos con
  /// contenido, la flecha se queda: pedido explícito del usuario,
  /// 2026-09-20.
  bool get tieneDetalle => descripcion.isNotEmpty || objetivos.isNotEmpty;

  Actividad copyWith({bool? favorita, bool? valorada}) => Actividad(
    id: id,
    titulo: titulo,
    horario: horario,
    ponente: ponente,
    dia: dia,
    lugar: lugar,
    aforo: aforo,
    etiquetas: etiquetas,
    descripcion: descripcion,
    tituloObjetivos: tituloObjetivos,
    objetivos: objetivos,
    favorita: favorita ?? this.favorita,
    valorada: valorada ?? this.valorada,
    horaFin: horaFin,
    valorable: valorable,
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
