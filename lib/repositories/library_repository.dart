import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LibraryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBookToLibrary(Map<String, dynamic> bookData, String bookId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuario no autenticado');

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('my_books')
        .doc(bookId);

    final snapshot = await docRef.get();
    if (snapshot.exists) throw Exception('Este libro ya está en tu biblioteca');

    await docRef.set({
      ...bookData,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }
}
