// lib/main.dart
import 'package:book_review/blocs/auth/auth_bloc.dart';
import 'package:book_review/blocs/auth_status/auth_status_bloc.dart';
import 'package:book_review/blocs/auth_status/auth_status_state.dart';
import 'package:book_review/blocs/books/book_bloc.dart';
import 'package:book_review/blocs/books/book_detail_bloc.dart';
import 'package:book_review/blocs/library/library_bloc.dart';
import 'package:book_review/blocs/my_books/my_books_bloc.dart';
import 'package:book_review/blocs/review/review_bloc.dart';
import 'package:book_review/firebase_options.dart';
import 'package:book_review/navigation/app_navigation.dart';
import 'package:book_review/repositories/auth_repository.dart';
import 'package:book_review/repositories/book_repository.dart';
import 'package:book_review/repositories/library_repository.dart';
import 'package:book_review/repositories/my_books_repository.dart';
import 'package:book_review/repositories/review_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authRepository = AuthRepository();
  final bookRepository = BookRepository();
  final reviewRepository = ReviewRepository();
  final libraryRepository = LibraryRepository();
  final myBooksRepository = MyBooksRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository: authRepository)),
        BlocProvider(create: (_) => AuthStatusBloc()),
        BlocProvider(create: (_) => BookBloc(bookRepository: bookRepository)),
        BlocProvider(create: (_) => BookDetailBloc(bookRepository: bookRepository)),
        BlocProvider(create: (_) => ReviewBloc(reviewRepository)),
        BlocProvider(create: (_) => LibraryBloc(libraryRepository)),
        BlocProvider(create: (_) => MyBooksBloc(myBooksRepository))
      ], 
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Review',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthStatusBloc, AuthStatusState>(
        builder: (context, state) {
          switch(state.status){
            case AuthStatus.authenticated:
              return const MainNavigation();
            case AuthStatus.unauthenticated:
              return const LoginScreen();
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      ),  
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainNavigation(),
      },
    );
  }
}
