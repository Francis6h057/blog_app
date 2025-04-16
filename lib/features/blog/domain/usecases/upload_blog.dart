// Importing the 'dart:io' library to work with files, specifically for handling images.
import 'dart:io';

// Importing custom Failure class used for error handling across the app.
import 'package:blog_app/core/error/failures.dart';

// Importing a base UseCase class that this class will implement.
import 'package:blog_app/core/usecase/usecase.dart';

// Importing the Blog entity which represents the data structure of a blog.
import 'package:blog_app/features/blog/domain/entities/blog.dart';

// Importing the BlogRepository interface to access blog-related data operations.
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';

// Importing fpdart's Either type to represent a value that can be either a Failure or a Success.
import 'package:fpdart/fpdart.dart';

/// A use case class for uploading a blog.
/// Implements the generic `UseCase` interface, which expects a return type and parameter type.
class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  // A reference to the BlogRepository that handles the actual data operations.
  final BlogRepository blogRepository;

  // Constructor to initialize the repository.
  UploadBlog(this.blogRepository);

  // The call method is invoked to execute the use case with the given parameters.
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    // Calls the uploadBlog method in the repository, passing the parameters.
    return await blogRepository.uploadBlog(
      image: params.image, // Blog image file.
      title: params.title, // Blog title.
      content: params.content, // Blog content/body.
      posterId: params.posterId, // ID of the user posting the blog.
      topics: params.topics, // List of topics/tags for the blog.
    );
  }
}

/// Class representing the parameters needed to upload a blog.
class UploadBlogParams {
  final String posterId; // ID of the user uploading the blog.
  final String title; // Blog title.
  final String content; // Blog content/body.
  final File image; // Image file to be uploaded with the blog.
  final List<String> topics; // List of selected topics/tags.

  // Constructor to initialize all required parameters.
  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
