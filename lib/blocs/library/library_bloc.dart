import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:book_review/repositories/library_repository.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository repository;

  LibraryBloc(this.repository) : super(LibraryInitial()) {
    on<AddBookToLibrary>(_onAddBookToLibrary);
  }

  Future<void> _onAddBookToLibrary(AddBookToLibrary event, Emitter<LibraryState> emit) async {
    emit(LibraryLoading());
    try {
      await repository.addBookToLibrary(event.bookData, event.bookId);
      emit(LibrarySuccess());
    } catch (e) {
      emit(LibraryFailure(e.toString()));
    }
  }
}
