import 'package:equatable/equatable.dart';

abstract class MyBooksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMyBooks extends MyBooksEvent {}
