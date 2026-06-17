import '../../data/eventos_data.dart';

class HistorialState {
  final List<Evento> eventos;
  final String query;
  final bool? presencial;

  const HistorialState({
    required this.eventos,
    this.query = '',
    this.presencial,
  });

  HistorialState copyWith({
    List<Evento>? eventos,
    String? query,
    bool? presencial,
    bool clearPresencial = false,
  }) {
    return HistorialState(
      eventos: eventos ?? this.eventos,
      query: query ?? this.query,
      presencial: clearPresencial ? null : (presencial ?? this.presencial),
    );
  }
}
