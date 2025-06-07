import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchBooks extends SearchEvent {
  final String query;

  const SearchBooks(this.query);

  @override
  List<Object> get props => [query];
}
