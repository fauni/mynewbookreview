import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:book_review/models/book.dart';

class MyBooksRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Book>> fetchMyBooks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("Usuario no autenticado");

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_books')
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Book(
        id: doc.id,
        title: data['title'],
        authors: List<String>.from(data['authors'] ?? []),
        imageLinks: data['thumbnail'] != null ? ImageLinks(thumbnail: data['thumbnail']) : null,
      );
    }).toList();
  }
}
