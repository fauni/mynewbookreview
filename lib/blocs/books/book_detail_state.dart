import 'package:book_review/models/book.dart';
import 'package:equatable/equatable.dart';

abstract class BookDetailState extends Equatable{
  const BookDetailState();

  @override
  List<Object> get props => [];
}

class BookDetailInitial extends BookDetailState{}

class BookDetailLoading extends BookDetailState{}

class BookDetailLoaded extends BookDetailState{
  final Book book;

  const BookDetailLoaded(this.book);

  @override
  List<Object> get props => [book];
}

class BookDetailError extends BookDetailState{
  final String message;

  const BookDetailError(this.message);

  @override
  List<Object> get props => [message];
}