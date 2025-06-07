part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddBookToLibrary extends LibraryEvent {
  final String bookId;
  final Map<String, dynamic> bookData;

  AddBookToLibrary(this.bookId, this.bookData);

  @override
  List<Object?> get props => [bookId, bookData];
}
