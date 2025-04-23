// Importing necessary Dart and package libraries.
import 'dart:io'; // Required for working with File type (used in image uploading)
import 'package:blog_app/core/common/cubits/connection_cubit/connection_cubit_cubit.dart';
import 'package:blog_app/core/error/exceptions.dart'; // Custom exception class
import 'package:blog_app/core/error/failures.dart'; // Custom failure class
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart'; // Local data source for caching or offline use
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart'; // Remote data source for blogs
import 'package:blog_app/features/blog/data/models/blog_model.dart'; // Blog model that implements Blog entity
import 'package:blog_app/features/blog/domain/entities/blog.dart'; // Blog domain entity
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart'; // Abstract repository interface
import 'package:fpdart/fpdart.dart'; // Functional programming package with Either
import 'package:uuid/uuid.dart'; // Used to generate unique IDs for blogs

// Implementation of the BlogRepository interface
class BlogRepositoryImpl implements BlogRepository {
  // Remote source for interacting with a backend server
  final BlogRemoteDataSource blogRemoteDataSource;

  // Local data source for caching and offline data persistence
  final BlogLocalDataSource blogLocalDataSource;

  // ConnectionCubit to handle real-time offline/online scenarios
  final ConnectionCubit connectionCubit;

  // Constructor injecting all dependencies
  BlogRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionCubit,
  );

  // Uploads a blog post to the server
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image, // Blog image file
    required String title, // Blog title
    required String content, // Blog content
    required String posterId, // User ID of the poster
    required List<String> topics, // List of associated topics/tags
  }) async {
    try {
      // Wait for the first emitted connection state (whether connected or not)
      final connectionState = await connectionCubit.stream.first;

      // Check for internet connection before proceeding
      if (!connectionState.isConnected) {
        return left(Failure('No internet connection'));
      }

      // Create a new blog model with initial data (no image yet)
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(), // Generate a unique ID for the blog
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '', // Placeholder for image URL
        topics: topics,
        updatedAt: DateTime.now(), // Set timestamp to now
      );

      // Upload image and receive its URL
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      // Update blog model with image URL
      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      // Upload the full blog (with image URL) to the server
      final uploadBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      // Return the uploaded blog wrapped in Right (success)
      return right(uploadBlog);
    } on ServerException catch (e) {
      // Return failure message if server exception occurs
      return left(Failure(e.message));
    }
  }

  // Fetches all blogs, tries local cache if offline
  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      // Wait for the first emitted connection state (whether connected or not)
      final connectionState = await connectionCubit.stream.first;

      // If there's no internet, load blogs from local cache
      if (!connectionState.isConnected) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }

      // Fetch blogs from remote source
      final blogs = await blogRemoteDataSource.getAllBlogs();

      // Cache them locally
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);

      // Return fetched blogs
      return right(blogs);
    } on ServerException catch (e) {
      // Return failure if server fails
      return left(Failure(e.message));
    }
  }
}
