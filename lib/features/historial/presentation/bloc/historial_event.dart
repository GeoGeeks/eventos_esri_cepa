abstract class HistorialEvent {}

class SearchEventChanged extends HistorialEvent {
  final String query;
  SearchEventChanged(this.query);
}

class FilterChanged extends HistorialEvent {
  final bool? presencial;
  FilterChanged(this.presencial);
}