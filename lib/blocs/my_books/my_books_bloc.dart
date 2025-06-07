import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_review/blocs/my_books/my_books_event.dart';
import 'package:book_review/blocs/my_books/my_books_state.dart';
import 'package:book_review/repositories/my_books_repository.dart';

class MyBooksBloc extends Bloc<MyBooksEvent, MyBooksState> {
  final MyBooksRepository repository;

  MyBooksBloc(this.repository) : super(MyBooksInitial()) {
    on<LoadMyBooks>(_onLoadMyBooks);
  }

  Future<void> _onLoadMyBooks(LoadMyBooks event, Emitter<MyBooksState> emit) async {
    emit(MyBooksLoading());
    try {
      final books = await repository.fetchMyBooks();
      emit(MyBooksLoaded(books));
    } catch (e) {
      emit(MyBooksError(e.toString()));
    }
  }
}
