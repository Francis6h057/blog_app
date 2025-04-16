part of 'auth_bloc.dart';

// Base class for all authentication-related states
@immutable
sealed class AuthState {
  const AuthState();
}

// Represents the initial state of authentication, before any action is taken
final class AuthInitial extends AuthState {}

// Represents the loading state during authentication processes like sign up or login
final class AuthLoading extends AuthState {}

// Represents a successful authentication, holds the user data
final class AuthSuccess extends AuthState {
  final User user;

  // Constructor to initialize the user field when authentication is successful
  const AuthSuccess(this.user);
}

// Represents a failure in authentication, holds an error message
final class AuthFailure extends AuthState {
  final String message;

  // Constructor to initialize the message field with the error message
  const AuthFailure(this.message);
}
