import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// Defines the access level and view preferences for the logged-in user.
enum AccountType { hybrid, msebOnly, generatorOnly }

/// Base class for all authentication events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final AccountType accountType;
  const LoginRequested(this.accountType);
  @override
  List<Object> get props => [accountType];
}

class LogoutRequested extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {
  final AccountType accountType;
  const AuthAuthenticated(this.accountType);
  @override
  List<Object> get props => [accountType];
}

class AuthUnauthenticated extends AuthState {}

/// The authentication BLoC responsible for managing the user's session state.
/// It listens for login and logout events and updates the state with the corresponding [AccountType].
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    // Handles the login request event
    on<LoginRequested>((event, emit) {
      emit(AuthAuthenticated(event.accountType));
    });

    // Handles the logout request event
    on<LogoutRequested>((event, emit) {
      emit(AuthUnauthenticated());
    });
  }
}
