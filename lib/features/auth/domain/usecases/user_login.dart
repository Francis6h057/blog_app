// Importing necessary packages and classes
import 'package:blog_app/core/error/failures.dart'; // Failure class to handle errors
import 'package:blog_app/core/usecase/usecase.dart'; // Base UseCase class that abstracts business logic
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // AuthRepository for user authentication methods
import 'package:fpdart/fpdart.dart'; // Functional programming library for handling Either type (Success/Failure)

// UserLogin class implements UseCase with a return type of User and input parameters of type UserLoginParams
class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository
      authRepository; // AuthRepository instance for user login functionality
  const UserLogin(
      this.authRepository); // Constructor initializing the authRepository

  // The call method is invoked to execute the use case logic
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    // Calls the loginWithEmailAndPassword method from the authRepository with email and password from params
    return await authRepository.loginWithEmailAndPassword(
      email: params.email, // Passing the email parameter
      password: params.password, // Passing the password parameter
    );
  }
}

// Class that holds parameters required for user login
class UserLoginParams {
  final String email; // User's email for login
  final String password; // User's password for login

  UserLoginParams({
    required this.email, // Constructor parameter for email
    required this.password, // Constructor parameter for password
  });
}
