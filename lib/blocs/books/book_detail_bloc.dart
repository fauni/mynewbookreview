import 'package:book_review/blocs/books/book_detail_event.dart';
import 'package:book_review/blocs/books/book_detail_state.dart';
import 'package:book_review/repositories/book_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState>{
  final BookRepository bookRepository;
  
  BookDetailBloc({required this.bookRepository}) : super(BookDetailInitial()){
    on<FetchBookDetail>(_onFetchDetailBook);
  }

  Future<void> _onFetchDetailBook(FetchBookDetail event, Emitter<BookDetailState> emit) async{
    emit(BookDetailLoading());
    try {
      final book = await bookRepository.getBookById(event.id);
      emit(BookDetailLoaded(book));
    } catch(e) {
      emit(BookDetailError(e.toString()));
    }
  }
  
}