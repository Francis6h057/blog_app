part of 'blog_bloc.dart';

/// Base class for all blog-related states.
///
/// Extend this to reflect different UI states based on blog actions.
@immutable
sealed class BlogState {}

/// Initial state before any actions have been triggered.
final class BlogInitial extends BlogState {}

/// State representing a loading process (e.g. uploading or fetching blogs).
final class BlogLoading extends BlogState {}

/// State emitted when a blog-related operation fails.
///
/// Carries an error message for user feedback or debugging.
final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);
}

/// State emitted when a blog is successfully uploaded.
final class BlogUploadSuccess extends BlogState {}

/// State emitted when blogs are successfully fetched from the server.
///
/// Contains a list of all retrieved blog objects.
final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;

  BlogDisplaySuccess(this.blogs);
}
