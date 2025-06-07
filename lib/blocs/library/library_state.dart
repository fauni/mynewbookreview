part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibrarySuccess extends LibraryState {}

class LibraryFailure extends LibraryState {
  final String message;

  LibraryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
