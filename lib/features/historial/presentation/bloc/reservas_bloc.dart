import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/eventos_data.dart';
import 'reservas_event.dart';
import 'reservas_state.dart';

class ReservasBloc extends Bloc<ReservasEvent, ReservasState> {
  ReservasBloc()
      : super(
          ReservasState(
            eventos: eventosMock,
          ),
        ) {
    on<SearchEventChanged>(_onSearch);
    on<FilterChanged>(_onFilter);
  }

  void _onSearch(
    SearchEventChanged event,
    Emitter<ReservasState> emit,
  ) {
    final filtered = eventosMock.where((e) {
      final matchSearch = e.titulo
          .toLowerCase()
          .contains(event.query.toLowerCase());

      final matchFilter = state.presencial == null
          ? true
          : e.presencial == state.presencial;

      return matchSearch && matchFilter;
    }).toList();

    emit(
      state.copyWith(
        query: event.query,
        eventos: filtered,
      ),
    );
  }

  void _onFilter(
    FilterChanged event,
    Emitter<ReservasState> emit,
  ) {
    final filtered = eventosMock.where((e) {
      final matchSearch = e.titulo
          .toLowerCase()
          .contains(state.query.toLowerCase());

      final matchFilter = event.presencial == null
          ? true
          : e.presencial == event.presencial;

      return matchSearch && matchFilter;
    }).toList();

    emit(
      state.copyWith(
        presencial: event.presencial,
        eventos: filtered,
      ),
    );
  }
}