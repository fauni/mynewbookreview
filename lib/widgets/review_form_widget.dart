import 'package:book_review/blocs/review/review_bloc.dart';
import 'package:book_review/blocs/review/review_event.dart';
import 'package:book_review/models/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ReviewFormWidget extends StatefulWidget {
  final String bookId;
  const ReviewFormWidget({super.key, required this.bookId });

  @override
  State<ReviewFormWidget> createState() => _ReviewFormWidgetState();
}

class _ReviewFormWidgetState extends State<ReviewFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      final newReview = Review(
        id: '', // Firestore lo generará
        bookId: widget.bookId,
        userId: '', // Reemplaza por ID real si usas auth
        userEmail: '',  // Reemplaza por nombre real
        rating: _rating,
        comment: _commentController.text,
        createdAt: DateTime.now(),
      );

      context.read<ReviewBloc>().add(AddReview(newReview));
      _commentController.clear();
      setState(() {
        _rating = 5;
      });
    }
  }
  
   @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(labelText: 'Tu reseña'),
            validator: (value) =>
                value == null || value.isEmpty ? 'Ingresa un comentario' : null,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Calificación:'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: _rating,
                items: [1, 2, 3, 4, 5]
                    .map((r) => DropdownMenuItem(value: r, child: Text('$r')))
                    .toList(),
                onChanged: (val) {
                  setState(() => _rating = val!);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _submitReview,
            icon: const Icon(Icons.send),
            label: const Text('Enviar reseña'),
          ),
        ],
      ),
    );
  }
}