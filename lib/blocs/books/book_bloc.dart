import 'package:book_review/blocs/books/book_event.dart';
import 'package:book_review/blocs/books/book_state.dart';
import 'package:book_review/repositories/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState>{
  final BookRepository bookRepository;
  
  BookBloc({required this.bookRepository}) : super(BookInitial()){
    on<FetchBooks>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async{
    emit(BookLoading());
    try {
      final books = await bookRepository.getBooks();
      emit(BookLoaded(books));
    } catch(e) {
      emit(BookError(e.toString()));
    }
  }
}