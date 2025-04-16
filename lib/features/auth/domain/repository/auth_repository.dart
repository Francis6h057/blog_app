// Importing necessary packages and classes
import 'package:blog_app/core/error/failures.dart'; // Failure class to handle errors
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:fpdart/fpdart.dart'; // Functional programming library for handling Either type (Success/Failure)

// Abstract class for AuthRepository, which defines the authentication-related methods
abstract interface class AuthRepository {
  // Method for signing up a user with email and password
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name, // The user's name
    required String email, // The user's email
    required String password, // The user's password
  });

  // Method for logging in a user with email and password
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email, // The user's email
    required String password, // The user's password
  });

  // Method for getting the current logged-in user
  Future<Either<Failure, User>> currentUser();
}
