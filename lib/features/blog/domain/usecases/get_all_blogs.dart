// Importing the custom Failure class used for error handling across the app.
import 'package:blog_app/core/error/failures.dart';

// Importing the base UseCase class that this class will implement.
import 'package:blog_app/core/usecase/usecase.dart';

// Importing the Blog entity which represents the data structure of a blog.
import 'package:blog_app/features/blog/domain/entities/blog.dart';

// Importing the BlogRepository interface to access blog-related data operations.
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';

// Importing fpdart's Either type to represent a value that can be either a Failure or a Success.
import 'package:fpdart/fpdart.dart';

/// A use case class to get all blogs.
/// Implements the generic `UseCase` interface, which expects a return type and parameter type.
class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  // A reference to the BlogRepository that handles the actual data operations.
  final BlogRepository blogRepository;

  // Constructor to initialize the repository.
  GetAllBlogs(this.blogRepository);

  // The call method is invoked to execute the use case with the given parameters (which are `NoParams` in this case).
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    // Calls the getAllBlogs method in the repository to fetch the list of all blogs.
    return await blogRepository.getAllBlogs();
  }
}
