import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String bookId;
  final String userId;
  final String userEmail;
  final int rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.userEmail,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  /// Convertir desde Firestore
  factory Review.fromMap(String id, String bookId, Map<String, dynamic> map) {
    return Review(
      id: id,
      bookId: bookId,
      userId: map['userId'] ?? '',
      userEmail: map['userEmail'] ?? '',
      rating: map['rating'] ?? 0,
      comment: map['comment'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userEmail,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
