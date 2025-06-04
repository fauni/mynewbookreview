import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthStatusEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthStatusChanged extends AuthStatusEvent {
  final User? user;
  AuthStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AppLogoutRequested extends AuthStatusEvent {
  @override
  List<Object?> get props => [];
}