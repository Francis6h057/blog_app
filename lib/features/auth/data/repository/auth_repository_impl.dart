// Importing necessary packages and classes
import 'package:blog_app/core/error/exceptions.dart'; // Custom exception class
import 'package:blog_app/core/error/failures.dart'; // Custom failure class for error handling
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart'; // Data source for authentication
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // Interface for authentication repository
import 'package:fpdart/fpdart.dart'; // Functional programming library for Either type (to handle success/failure)
import 'package:supabase_flutter/supabase_flutter.dart'
    as sb; // Supabase library, aliased to prevent clash with 'User' class

// Implementation of the AuthRepository interface
class AuthRepositoryImpl implements AuthRepository {
  // Injecting the remote data source for authentication
  final AuthRemoteDataSource remoteDataSource;

  final ConnectionChecker connectionChecker;

  // Constructor to initialize the repository with the remote data source
  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionChecker,
  );

  // Method to get the current logged-in user
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            name: '',
            email: session.user.email ?? '',
          ),
        );
      }
      // Attempt to retrieve the current user from the remote data source
      final user = await remoteDataSource.getCurrentUser();

      // If no user is found, return a failure indicating that the user is not logged in
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      // If user is found, return it as a successful result (right side of Either)
      return right(user);
    } on ServerException catch (e) {
      // If there's a server exception, return a failure with the exception's message
      return left(Failure(e.message));
    }
  }

  // Method to log in a user with email and password
  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // Calls the helper method to handle the login and error cases
    return _getUser(
      () async => await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  // Method to sign up a user with email, password, and name
  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    // Calls the helper method to handle the sign-up and error cases
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  // Private helper method to handle user creation for both login and sign-up
  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn, // Accepts a function that returns a User
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(
          Failure('No internet Connection'),
        );
      }
      // Attempts to execute the passed function to get a user
      final user = await fn();

      // If successful, return the user as a successful result (right side of Either)
      return right(user);
    } on sb.AuthException catch (e) {
      // If an authentication exception is thrown, return a failure with the exception's message
      return left(Failure(e.message));
    } on ServerException catch (e) {
      // If a server exception is thrown, return a failure with the exception's message
      return left(Failure(e.message));
    }
  }
}
