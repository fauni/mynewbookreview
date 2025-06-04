import 'package:book_review/blocs/review/review_event.dart';
import 'package:book_review/blocs/review/review_state.dart';
import 'package:book_review/repositories/review_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState>{
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()){
    on<LoadReviews>(_onLoadReviews);
    on<AddReview>(_onAddReview);
    on<UpdateReview>(_onUpdateReview);
    on<DeleteReview>(_onDeleteReview);
  }

  Future<void> _onLoadReviews(LoadReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviews = await repository.fetchReviews(event.bookId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    try {
      await repository.addReview(event.review);
      add(LoadReviews(event.review.bookId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onUpdateReview(UpdateReview event, Emitter<ReviewState> emit) async {
    try {
      await repository.updateReview(event.bookId, event.reviewId, event.newComment, event.newRating);
      add(LoadReviews(event.bookId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> _onDeleteReview(DeleteReview event, Emitter<ReviewState> emit) async {
    try {
      await repository.deleteReview(event.bookId, event.reviewId);
      add(LoadReviews(event.bookId));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}