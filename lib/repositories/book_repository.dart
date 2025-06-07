import 'dart:convert';

import 'package:book_review/models/book.dart';
import 'package:http/http.dart' as http;

class BookRepository {
  final String _baseUrl = 'https://reactnd-books-api.udacity.com';
  final String _token = 'token-prueba';

  Future<List<Book>> getBooks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/books'),
      headers: {'Authorization': _token},
    );
    if(response.statusCode == 200)
    {
      final data = json.decode(response.body);
      final List<dynamic> bokksJson = data['books'];
      return bokksJson.map((bookJson) => Book.fromJson(bookJson)).toList();
    } else {
      throw Exception('Error al obtener los libros');
    }
  }

  Future<Book> getBookById(String id)async {
    final response = await http.get(
      Uri.parse('$_baseUrl/books/$id'),
      headers: {'Authorization': _token},
    );  
    if(response.statusCode == 200){
      final data = json.decode(response.body);
      return Book.fromJson(data['book']);
    } else {
      throw Exception('Error al obtener el libro con ID: $id');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    final response = await http.post(
      Uri.parse('https://reactnd-books-api.udacity.com/search'),
      headers: {
        'Authorization': 'token-prueba',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': query, 'maxResults': 20}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['books'] != null && data['books'] is List) {
        final books = (data['books'] as List)
            .map((bookJson) => Book.fromJson(bookJson))
            .toList();
        return books;
      } else {
        return []; // no books found
      }
    } else {
      throw Exception('Error al buscar libros');
    }
  }

}