part of 'auth_bloc.dart';

// Base class for all authentication-related events
@immutable
sealed class AuthEvent {}

// Event for signing up a user, requiring name, email, and password
final class AuthSignUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  // Constructor to initialize the fields for sign-up
  AuthSignUp({
    required this.name,
    required this.email,
    required this.password,
  });
}

// Event for logging in a user, requiring email and password
final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  // Constructor to initialize the fields for login
  AuthLogin({
    required this.email,
    required this.password,
  });
}

// Event to check if a user is currently logged in, no additional parameters needed
final class AuthIsUserLoggedIn extends AuthEvent {}
