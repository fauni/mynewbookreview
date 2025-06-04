import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthStatusState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthStatusState._({required this.status, this.user});

  const AuthStatusState.unknown() : this._(status: AuthStatus.unknown);
  const AuthStatusState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);
  const AuthStatusState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user ?? ''];
}