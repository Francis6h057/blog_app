part of 'blog_bloc.dart';

/// Base class for all blog-related events.
///
/// Extend this to add more blog functionality (e.g. delete, update).
@immutable
sealed class BlogEvent {}

/// Event triggered when a user uploads a new blog.
///
/// Carries all required fields for blog creation.
final class BlogUpload extends BlogEvent {
  final String posterId; // ID of the user posting the blog
  final String title; // Blog title
  final String content; // Blog body/content
  final File image; // Blog image file
  final List<String> topics; // Selected blog topics/tags

  BlogUpload({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}

/// Event to fetch all blogs from the backend.
final class BlogFetchAllBlogs extends BlogEvent {}
