// Importing necessary packages and classes
import 'package:blog_app/core/common/cubits/connection_cubit/connection_cubit_cubit.dart';
import 'package:blog_app/core/error/exceptions.dart'; // Custom exception class
import 'package:blog_app/core/error/failures.dart'; // Custom failure class for error handling
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart'; // Data source for authentication
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:blog_app/features/auth/data/models/user_model.dart'; // User model class extending User entity
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // Interface for authentication repository
import 'package:fpdart/fpdart.dart'; // Functional programming library for Either type (to handle success/failure)

// Implementation of the AuthRepository interface
class AuthRepositoryImpl implements AuthRepository {
  // Injecting the remote data source for authentication
  final AuthRemoteDataSource remoteDataSource;

  // Internet connection cubit to handle real-time offline/online scenarios
  final ConnectionCubit connectionCubit;

  // Constructor to initialize dependencies
  const AuthRepositoryImpl(
    this.remoteDataSource,
    this.connectionCubit,
  );

  // Method to retrieve the currently authenticated user
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      // Listen to the connection stream and get the first state (connected or not)
      final connectionState = await connectionCubit.stream.first;

      // Check if there is no internet connection
      if (!connectionState.isConnected) {
        // Get current user session stored locally
        final session = remoteDataSource.currentUserSession;

        // If session is null, user is not logged in
        if (session == null) {
          return left(Failure('User not logged in!'));
        }

        // Return a UserModel created from session data
        return right(
          UserModel(
            id: session.user.id,
            name: session.user.email ?? '',
            email: session.user.email ?? '',
          ),
        );
      }

      // If internet is available, get user from Supabase
      final user = await remoteDataSource.getCurrentUser();

      // If user is null, return failure
      if (user == null) {
        return left(Failure('User not logged in!'));
      }

      // Return the retrieved user
      return right(user);
    } on ServerException catch (e) {
      // Handle custom server-side exceptions
      return left(Failure(e.message));
    }
  }

  // Method to log in using email and password
  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  // Method to sign up a user using name, email and password
  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  // Shared helper function to handle both login and signup logic
  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn, // Takes a callback that returns a User
  ) async {
    try {
      // Listen to the connection stream and get the first state (connected or not)
      final connectionState = await connectionCubit.stream.first;

      // Check if there is no internet connection
      if (!connectionState.isConnected) {
        return left(Failure('No internet Connection'));
      }

      // Attempt to get the user from the passed function
      final user = await fn();

      // Return the user if successful
      return right(user);
    } on ServerException catch (e) {
      // Handle custom server exceptions
      return left(Failure(e.message));
    }
  }
}
