abstract class ReservasEvent {}

class SearchEventChanged extends ReservasEvent {
  final String query;

  SearchEventChanged(this.query);
}

class FilterChanged extends ReservasEvent {
  final bool? presencial;

  FilterChanged(this.presencial);
}