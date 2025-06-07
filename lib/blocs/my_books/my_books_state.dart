import 'package:equatable/equatable.dart';
import 'package:book_review/models/book.dart';

abstract class MyBooksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyBooksInitial extends MyBooksState {}

class MyBooksLoading extends MyBooksState {}

class MyBooksLoaded extends MyBooksState {
  final List<Book> books;

  MyBooksLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class MyBooksError extends MyBooksState {
  final String message;

  MyBooksError(this.message);

  @override
  List<Object?> get props => [message];
}
