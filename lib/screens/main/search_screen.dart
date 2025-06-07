import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_review/blocs/search/search_bloc.dart';
import 'package:book_review/blocs/search/search_event.dart';
import 'package:book_review/blocs/search/search_state.dart';
import 'package:book_review/screens/main/book_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _onSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      context.read<SearchBloc>().add(SearchBooks(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Libros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ingrese título o autor',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ),
              onSubmitted: (_) => _onSearch(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SearchSuccess) {
                    if (state.books.isEmpty) {
                      return const Center(child: Text('No se encontraron libros.'));
                    }
                    return ListView.builder(
                      itemCount: state.books.length,
                      itemBuilder: (context, index) {
                        final book = state.books[index];
                        return ListTile(
                          leading: book.imageLinks?.thumbnail != null
                              ? Image.network(book.imageLinks!.thumbnail!, width: 50)
                              : const Icon(Icons.book),
                          title: Text(book.title ?? 'Sin título'),
                          subtitle: Text(book.authors?.join(', ') ?? ''),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookDetailScreen(bookId: book.id!),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const Center(child: Text('Realiza una búsqueda.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
