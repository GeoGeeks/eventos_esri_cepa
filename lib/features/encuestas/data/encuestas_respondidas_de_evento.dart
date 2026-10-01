import 'encuesta.dart';

/// Encuestas que la persona ya respondió en un evento, tal como las agrupa
/// `GET /encuestas/respondidas` ("Mis encuestas" en Perfil). La API ya
/// decide el orden (respuesta más reciente primero) y el nombre del evento.
class EncuestasRespondidasDeEvento {
  const EncuestasRespondidasDeEvento({
    required this.idEvento,
    required this.nombreEvento,
    required this.encuestas,
  });

  final String idEvento;
  final String nombreEvento;

  /// Todas con [Encuesta.yaRespondida] en `true`.
  final List<Encuesta> encuestas;

  factory EncuestasRespondidasDeEvento.fromJson(Map<String, dynamic> json) {
    final encuestas = (json['encuestas'] as List<dynamic>? ?? [])
        .map(
          (e) => Encuesta.fromJson({
            ...e as Map<String, dynamic>,
            'yaRespondida': true,
          }),
        )
        .toList();
    return EncuestasRespondidasDeEvento(
      idEvento: json['idEvento'] as String,
      nombreEvento: json['nombreEvento'] as String,
      encuestas: encuestas,
    );
  }
}
