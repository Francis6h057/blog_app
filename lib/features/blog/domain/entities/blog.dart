// Define the Blog class, which represents a blog post entity in the application.
class Blog {
  // The unique identifier for the blog post.
  final String id;

  // The ID of the user who posted the blog.
  final String posterId;

  // The title of the blog post.
  final String title;

  // The content of the blog post.
  final String content;

  // The URL to the image associated with the blog post (if any).
  final String imageUrl;

  // A list of topics/categories that are related to the blog post.
  final List<String> topics;

  // The date and time when the blog post was last updated.
  final DateTime updatedAt;

  // The name of the poster (author) of the blog post. This field is optional.
  final String? posterName;

  // Constructor to initialize all required and optional fields.
  Blog({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.posterName, // This is an optional parameter, hence the use of 'this.posterName'.
  });
}
