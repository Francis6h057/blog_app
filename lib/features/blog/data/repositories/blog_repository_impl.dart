// Importing necessary Dart and package libraries.
import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart'; // Custom exception class
import 'package:blog_app/core/error/failures.dart'; // Custom failure class
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart'; // Data source to handle remote blog data
import 'package:blog_app/features/blog/data/models/blog_model.dart'; // Model class to represent a Blog
import 'package:blog_app/features/blog/domain/entities/blog.dart'; // Entity class representing the Blog domain entity
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart'; // The repository interface
import 'package:fpdart/fpdart.dart'; // Functional programming library
import 'package:uuid/uuid.dart'; // Library to generate unique identifiers

// Implementation of BlogRepository interface, which interacts with the remote data source
class BlogRepositoryImpl implements BlogRepository {
  // Instance of the BlogRemoteDataSource, used for making remote calls related to blog data.
  final BlogRemoteDataSource blogRemoteDataSource;

  final BlogLocalDataSource blogLocalDataSource;

  final ConnectionChecker connectionChecker;

  // Constructor initializing the blogRemoteDataSource.
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  // Overriding the method to upload a new blog post
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image, // The blog's image file
    required String title, // The title of the blog
    required String content, // The content of the blog post
    required String posterId, // The ID of the user posting the blog
    required List<String>
        topics, // List of topics associated with the blog post
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection'));
      }
      // Creating a new BlogModel instance with the given data.
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(), // Generates a unique ID for the blog post.
        posterId: posterId, // Assigning the poster's ID to the blog post.
        title: title, // Assigning the blog's title.
        content: content, // Assigning the blog's content.
        imageUrl: '', // Placeholder for image URL (initially empty).
        topics: topics, // Assigning the list of topics.
        updatedAt: DateTime
            .now(), // Assigning the current date and time as the updated time.
      );

      // Uploading the blog's image using the data source and getting the image URL.
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image, // Passing the image file to the method
        blog: blogModel, // Passing the current blog model (without image URL)
      );

      // Updating the blogModel with the new image URL returned from the image upload.
      blogModel = blogModel.copyWith(
        imageUrl:
            imageUrl, // Assigning the returned image URL to the blogModel.
      );

      // Uploading the complete blog (including the image URL) to the remote server.
      final uploadBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      // If everything succeeds, return the result of the upload as the right side of the Either.
      return right(uploadBlog);
    } on ServerException catch (e) {
      // In case of an error, we catch the ServerException and return it as a Failure on the left side.
      return left(Failure(e.message));
    }
  }

  // Overriding the method to fetch all blogs
  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }

      // Fetching all blogs from the remote data source
      final blogs = await blogRemoteDataSource.getAllBlogs();

      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      // Returning the list of blogs wrapped in a right side of the Either
      return right(blogs);
    } on ServerException catch (e) {
      // In case of an error, we catch the ServerException and return it as a Failure on the left side.
      return left(Failure(e.message));
    }
  }
}
