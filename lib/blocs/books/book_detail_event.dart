import 'package:equatable/equatable.dart';

abstract class BookDetailEvent extends Equatable{
  const BookDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchBookDetail extends BookDetailEvent {
  final String id;

  const FetchBookDetail(this.id);

  @override
  List<Object> get props => [id];

}