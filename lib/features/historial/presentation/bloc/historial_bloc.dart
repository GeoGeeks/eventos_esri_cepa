import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/eventos_data.dart';
import 'historial_event.dart';
import 'historial_state.dart';

class HistorialBloc extends Bloc<HistorialEvent, HistorialState> {
  HistorialBloc()
      : super(
          HistorialState(
            eventos: eventosMock,
          ),
        ) {
    on<SearchEventChanged>(_onSearch);
    on<FilterChanged>(_onFilter);
  }

  void _onSearch(
    SearchEventChanged event,
    Emitter<HistorialState> emit,
  ) {
    final filtered = eventosMock.where((e) {
      final matchSearch =
          e.titulo.toLowerCase().contains(event.query.toLowerCase());
      final matchFilter =
          state.presencial == null ? true : e.presencial == state.presencial;
      return matchSearch && matchFilter;
    }).toList();

    emit(state.copyWith(query: event.query, eventos: filtered));
  }

  void _onFilter(
    FilterChanged event,
    Emitter<HistorialState> emit,
  ) {
    final filtered = eventosMock.where((e) {
      final matchSearch =
          e.titulo.toLowerCase().contains(state.query.toLowerCase());
      final matchFilter =
          event.presencial == null ? true : e.presencial == event.presencial;
      return matchSearch && matchFilter;
    }).toList();

    emit(
      state.copyWith(
        presencial: event.presencial,
        clearPresencial: event.presencial == null,
        eventos: filtered,
      ),
    );
  }
}