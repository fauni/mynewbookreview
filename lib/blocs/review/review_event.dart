import 'package:book_review/models/review.dart';
import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable{
  const ReviewEvent();

  @override
  List<Object> get props => [];
}

class LoadReviews extends ReviewEvent {
  final String bookId;
  const LoadReviews(this.bookId);

  @override
  List<Object> get props => [bookId];
}

class AddReview extends ReviewEvent {
  final Review review;
  const AddReview(this.review);

  @override
  List<Object> get props => [review];
}

class UpdateReview extends ReviewEvent {
  final String bookId;
  final String reviewId;
  final String newComment;
  final int newRating;

  const UpdateReview(this.bookId, this.reviewId, this.newComment, this.newRating);

  @override
  List<Object> get props => [bookId, reviewId, newComment, newRating];
}

class DeleteReview extends ReviewEvent {
  final String bookId;
  final String reviewId;

  const DeleteReview(this.bookId, this.reviewId);

  @override
  List<Object> get props => [bookId, reviewId];
}

