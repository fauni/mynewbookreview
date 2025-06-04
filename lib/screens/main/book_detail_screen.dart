import 'package:book_review/blocs/books/book_detail_bloc.dart';
import 'package:book_review/blocs/books/book_detail_event.dart';
import 'package:book_review/blocs/books/book_detail_state.dart';
import 'package:book_review/blocs/review/review_bloc.dart';
import 'package:book_review/blocs/review/review_event.dart';
import 'package:book_review/blocs/review/review_state.dart';
import 'package:book_review/models/review.dart';
import 'package:book_review/widgets/review_form_widget.dart';
import 'package:book_review/widgets/starting_rating_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookDetailBloc>().add(FetchBookDetail(widget.bookId));
    context.read<ReviewBloc>().add(LoadReviews(widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Libro'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implementar compartir
            },
          ),
        ],
      ),
      body: BlocConsumer<BookDetailBloc, BookDetailState>(
        listener: (context, state) {
          if (state is BookDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookDetailLoaded) {
            final book = state.book;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Portada del libro con sombra y borde redondeado
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: book.imageLinks?.thumbnail != null
                            ? Image.network(
                                book.imageLinks!.thumbnail!,
                                height: 250,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Título con estilo mejorado
                  Text(
                    book.title ?? 'Título no disponible',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Autores con icono
                  if (book.authors?.isNotEmpty ?? false)
                    Row(
                      children: [
                        const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          book.authors!.join(', '),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.blueGrey[600],
                              ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Fecha de publicación con icono
                  if (book.publishedDate != null)
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Publicado: ${_formatDate(book.publishedDate!)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),

                  // Descripción con título sección
                  if (book.description != null) ...[
                    Text(
                      'Descripción',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                      textAlign: TextAlign.justify,
                    ),
                  ],

                  // Botón de acción
                  const SizedBox(height: 32),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text('Comprar este libro'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Acción de compra
                      },
                    ),
                  ),

                  // Aqui agregar reseñas
                  const SizedBox(height: 32),
                  Text(
                    'Reseñas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(height: 12),

                  // Mostrar lista de reseñas
                  BlocBuilder<ReviewBloc, ReviewState>(
                    builder: (context, state) {
                      if (state is ReviewLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ReviewLoaded) {
                        if (state.reviews.isEmpty) {
                          return const Text('No hay reseñas aún.');
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.reviews.length,
                          itemBuilder: (context, index) {
                            final review = state.reviews[index];
                            final isAuthor = review.userId == FirebaseAuth.instance.currentUser?.uid;
                            return ListTile(
                              leading: CircleAvatar(child: Text(review.userEmail[0])),
                              title: Text(review.userEmail, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StarRating(rating: review.rating, size: 16),
                                  const SizedBox(height: 4),
                                  Text(review.comment),
                                ],
                              ),
                              trailing: isAuthor 
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _showEditDialog(context, review), 
                                        icon: const Icon(Icons.edit, color: Colors.grey)
                                      ),
                                      IconButton(
                                        onPressed: () => context.read<ReviewBloc>().add(
                                          DeleteReview(widget.bookId, review.id)
                                        ), 
                                        icon: const Icon(Icons.delete, color: Colors.red)
                                      )
                                    ],
                                  ) 
                                : null,
                            );
                          },
                        );
                      } else if (state is ReviewError) {
                        return Text('Error al cargar reseñas: ${state.message}');
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                  const Divider(height: 32),

                  // Formulario para nueva reseña
                  ReviewFormWidget(bookId: widget.bookId),
                ],
              ),
            );
          } else if (state is BookDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<BookDetailBloc>().add(FetchBookDetail(widget.bookId)),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No se encontraron datos'));
          }
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 250,
      width: 180,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.book, size: 60, color: Colors.grey),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.tryParse(dateString);
      if (date != null) {
        return '${date.day}/${date.month}/${date.year}';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  void _showEditDialog(BuildContext context, Review review) {
    final commentController = TextEditingController(text: review.comment);
    int rating = review.rating;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Reseña'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: commentController,
              decoration: const InputDecoration(labelText: 'Comentario'),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: rating,
              isExpanded: true,
              items: [1, 2, 3, 4, 5].map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text('$e estrellas'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    rating = value;
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              context.read<ReviewBloc>().add(UpdateReview(
                    review.bookId,
                    review.id,
                    commentController.text.trim(),
                    rating,
                  ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

}