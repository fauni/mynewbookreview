import 'package:book_review/blocs/my_books/my_books_bloc.dart';
import 'package:book_review/blocs/my_books/my_books_event.dart';
import 'package:book_review/blocs/my_books/my_books_state.dart';
import 'package:book_review/repositories/my_books_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBooksScreen extends StatelessWidget {
  const MyBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyBooksBloc(MyBooksRepository())..add(LoadMyBooks()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Mis Libros")),
        body: BlocBuilder<MyBooksBloc, MyBooksState>(
          builder: (context, state) {
            if (state is MyBooksLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyBooksLoaded) {
              if (state.books.isEmpty) return const Center(child: Text('No hay libros aún.'));
              return ListView.builder(
                itemCount: state.books.length,
                itemBuilder: (_, index) {
                  final book = state.books[index];
                  return ListTile(
                    leading: book.imageLinks?.thumbnail != null
                        ? Image.network(book.imageLinks!.thumbnail!, width: 50, fit: BoxFit.cover)
                        : const Icon(Icons.book),
                    title: Text(book.title ?? 'Sin título'),
                    subtitle: Text(book.authors?.join(', ') ?? ''),
                  );
                },
              );
            } else if (state is MyBooksError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
