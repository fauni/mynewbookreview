import 'package:book_review/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewRepository {
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;


  /// Obtener reseñas desde `books/{bookId}/reviews`
  Future<List<Review>> fetchReviews(String bookId) async {
    final snapshot = await _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return Review.fromMap(doc.id, bookId, doc.data());
    }).toList();
  }

  /// Agregar una nueva reseña a `books/{bookId}/reviews`
  Future<void> addReview(Review review) async {
    await _firestore
        .collection('books')
        .doc(review.bookId)
        .collection('reviews')
        .add({
      'userId': user!.uid,
      'userEmail': user!.email,
      'rating': review.rating,
      'comment': review.comment,
      'createdAt': Timestamp.fromDate(review.createdAt),
    });
  }

  Future<void> updateReview(String bookId, String reviewId, String newComment, int newRating) async {
    await _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .doc(reviewId)
        .update({
          'comment': newComment,
          'rating': newRating,
          'createdAt': DateTime.now(),
        });
  }

  Future<void> deleteReview(String bookId, String reviewId) async {
    await _firestore
        .collection('books')
        .doc(bookId)
        .collection('reviews')
        .doc(reviewId)
        .delete();
  }

}