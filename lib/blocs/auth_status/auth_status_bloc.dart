
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_status_event.dart';
import 'auth_status_state.dart';


class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStatusState> {
  final FirebaseAuth _firebaseAuth;

  AuthStatusBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthStatusState.unknown()) {
    on<AuthStatusChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _firebaseAuth.authStateChanges().listen((user) {
      add(AuthStatusChanged(user));
    });
  }

  void _onUserChanged(AuthStatusChanged event, Emitter<AuthStatusState> emit) {
    if (event.user != null) {
      emit(AuthStatusState.authenticated(event.user!));
    } else {
      emit(const AuthStatusState.unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(AppLogoutRequested event, Emitter<AuthStatusState> emit) async {
    await _firebaseAuth.signOut();
  }
}
