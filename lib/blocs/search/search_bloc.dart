import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_review/blocs/search/search_event.dart';
import 'package:book_review/blocs/search/search_state.dart';
import 'package:book_review/repositories/book_repository.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final BookRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onSearchBooks(SearchBooks event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final results = await repository.searchBooks(event.query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
