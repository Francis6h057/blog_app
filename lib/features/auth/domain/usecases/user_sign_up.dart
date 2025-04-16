// Importing necessary packages and classes
import 'package:blog_app/core/error/failures.dart'; // Failure class for error handling
import 'package:blog_app/core/usecase/usecase.dart'; // Base UseCase class to abstract business logic
import 'package:blog_app/core/common/entities/user.dart'; // User entity class representing the user data
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // AuthRepository for user authentication methods
import 'package:fpdart/fpdart.dart'; // Functional programming library providing Either type (Success/Failure)

// UserSignUp class implements UseCase with a return type of User and input parameters of type UserSignUpParams
class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository
      authRepository; // Instance of AuthRepository for signing up the user

  const UserSignUp(
      this.authRepository); // Constructor initializing the authRepository

  // The call method is invoked to execute the use case logic
  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    // Calls the signUpWithEmailAndPassword method from authRepository with provided parameters
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name, // Passing the name parameter
      email: params.email, // Passing the email parameter
      password: params.password, // Passing the password parameter
    );
  }
}

// Class that holds parameters required for user sign-up
class UserSignUpParams {
  final String name; // User's name for sign-up
  final String email; // User's email for sign-up
  final String password; // User's password for sign-up

  // Constructor for initializing the parameters
  UserSignUpParams({
    required this.name, // Constructor parameter for name
    required this.email, // Constructor parameter for email
    required this.password, // Constructor parameter for password
  });
}
