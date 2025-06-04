import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
  @override
  List<Object> get props => [];
}

class RegisterUserRequested extends AuthEvent {
  final String email;
  final String password;

  const RegisterUserRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
