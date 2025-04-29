// Import custom exception class to handle server-side errors
import 'package:blog_app/core/error/exceptions.dart';

// Import user model used to map Supabase user data to a Dart model
import 'package:blog_app/features/auth/data/models/user_model.dart';

// Import Supabase Flutter SDK for authentication and database operations
import 'package:supabase_flutter/supabase_flutter.dart';

// Define the abstract interface for authentication-related operations
abstract interface class AuthRemoteDataSource {
  // Getter for the current session of the logged-in user
  Session? get currentUserSession;

  // Method to register a new user using email, password, and name
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  // Method to log in an existing user using email and password
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  // Method to get the current logged-in user's profile from Supabase
  Future<UserModel?> getCurrentUser();
}

// Concrete implementation of AuthRemoteDataSource using Supabase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Dependency: Supabase client instance for accessing auth and DB
  final SupabaseClient supabaseClient;

  // Constructor to initialize Supabase client
  AuthRemoteDataSourceImpl(this.supabaseClient);

  // Getter to retrieve the current session of the user
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  // Implementation of user login using Supabase Auth
  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in the user with email and password
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      // If no user is returned, throw a custom server exception
      if (response.user == null) {
        throw const ServerException("User is null!");
      }

      // Convert the Supabase user to a UserModel and include email from session
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      // Handle Supabase authentication errors
      throw ServerException(e.message);
    } catch (e) {
      // Wrap and throw any error as a ServerException
      throw ServerException(e.toString());
    }
  }

  // Implementation of user sign-up using Supabase Auth
  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Sign up the user and pass 'name' as user metadata
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );

      // If no user is returned, throw a custom server exception
      if (response.user == null) {
        throw const ServerException("User is null!");
      }

      // Convert the Supabase user to a UserModel and include email from session
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } on AuthException catch (e) {
      // Handle Supabase authentication errors
      throw ServerException(e.message);
    } catch (e) {
      // Wrap and throw any error as a ServerException
      throw ServerException(e.toString());
    }
  }

  // Implementation of getting the current logged-in user's profile
  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check if a session exists (user is logged in)
      if (currentUserSession != null) {
        // Fetch user profile data from 'profiles' table where ID matches current user
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );

        // Convert the fetched profile data to a UserModel and include user's email
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      // Return null if no session exists (user is not logged in)
      return null;
    } catch (e) {
      // Wrap and throw any error as a ServerException
      throw ServerException(e.toString());
    }
  }
}
