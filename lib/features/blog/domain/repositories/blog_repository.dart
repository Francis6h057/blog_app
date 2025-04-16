// Importing the Dart IO library to handle file operations like reading and writing files.
import 'dart:io';

// Importing the Failure class to handle errors and failures throughout the app.
import 'package:blog_app/core/error/failures.dart';

// Importing the Blog entity to represent blog data.
import 'package:blog_app/features/blog/domain/entities/blog.dart';

// Importing fpdart's Either type for functional error handling. This will be used to represent either a failure or a success result.
import 'package:fpdart/fpdart.dart';

/// An abstract interface (contract) for the BlogRepository.
/// This repository defines the operations that the data layer (repository) must provide for blog-related tasks.
abstract interface class BlogRepository {
  /// Method for uploading a blog post.
  /// Returns a Future that resolves to an Either type, where:
  /// - On success, it returns a Blog object (the uploaded blog post).
  /// - On failure, it returns a Failure object.
  Future<Either<Failure, Blog>> uploadBlog({
    required File image, // The image associated with the blog post.
    required String title, // The title of the blog post.
    required String content, // The content of the blog post.
    required String posterId, // The ID of the user who is posting the blog.
    required List<String>
        topics, // The topics/categories associated with the blog.
  });

  /// Method for fetching all blogs.
  /// Returns a Future that resolves to an Either type, where:
  /// - On success, it returns a List of Blog objects (the list of all blogs).
  /// - On failure, it returns a Failure object.
  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
