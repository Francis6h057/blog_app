// Importing necessary packages and classes
import 'package:blog_app/core/error/failures.dart'; // Failure class to handle errors
import 'package:blog_app/core/usecase/usecase.dart'; // Base UseCase class that abstracts business logic
import 'package:blog_app/core/common/entities/user.dart'; // User entity class
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart'; // AuthRepository for fetching user-related data
import 'package:fpdart/fpdart.dart'; // Functional programming library for handling Either type (Success/Failure)

// CurrentUser class implements UseCase with a return type of User and no parameters (NoParams)
class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository
      authRepository; // AuthRepository instance to interact with the authentication layer

  // Constructor initializing the authRepository
  CurrentUser(this.authRepository);

  // The call method is invoked to execute the use case logic
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    // Calls the currentUser method from the authRepository to fetch the current authenticated user
    return await authRepository.currentUser();
  }
}
