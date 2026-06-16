import '../../data/eventos_data.dart';

class ReservasState {
  final List<Evento> eventos;
  final String query;
  final bool? presencial;

  const ReservasState({
    required this.eventos,
    this.query = '',
    this.presencial,
  });

  ReservasState copyWith({
    List<Evento>? eventos,
    String? query,
    bool? presencial,
  }) {
    return ReservasState(
      eventos: eventos ?? this.eventos,
      query: query ?? this.query,
      presencial: presencial,
    );
  }
}