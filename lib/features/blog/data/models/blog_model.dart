// Importing the Blog entity class to inherit from it
import 'package:blog_app/features/blog/domain/entities/blog.dart';

// BlogModel class extends Blog to provide a concrete implementation of the Blog entity.
class BlogModel extends Blog {
  // Constructor of BlogModel that passes parameters to the parent class (Blog) constructor.
  BlogModel(
      {required super.id, // Required ID for the blog.
      required super.posterId, // Required poster ID (author of the blog).
      required super.title, // Required title of the blog.
      required super.content, // Required content of the blog.
      required super.imageUrl, // Required image URL of the blog.
      required super.topics, // Required list of topics associated with the blog.
      required super.updatedAt, // Required updated time of the blog post.
      super.posterName}); // Optional poster name (the name of the author).

  // Method to convert the BlogModel instance to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id, // Converting the ID to JSON key-value pair.
      'poster_id': posterId, // Converting the poster ID to JSON key-value pair.
      'title': title, // Converting the title to JSON key-value pair.
      'content': content, // Converting the content to JSON key-value pair.
      'image_url': imageUrl, // Converting the image URL to JSON key-value pair.
      'topics': topics, // Converting the topics list to JSON key-value pair.
      'updated_at': updatedAt
          .toIso8601String(), // Converting the updatedAt date-time to a string in ISO 8601 format.
    };
  }

  // Factory constructor to create a BlogModel instance from a JSON map.
  factory BlogModel.fromJson(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id']
          as String, // Extracting 'id' from the JSON and casting it to String.
      posterId: map['poster_id']
          as String, // Extracting 'poster_id' and casting it to String.
      title: map['title']
          as String, // Extracting 'title' and casting it to String.
      content: map['content']
          as String, // Extracting 'content' and casting it to String.
      imageUrl: map['image_url']
          as String, // Extracting 'image_url' and casting it to String.
      topics: List<String>.from(map['topics'] ??
          []), // Extracting 'topics' as a List of Strings (default to an empty list if null).
      updatedAt: map['updated_at'] == null
          ? DateTime
              .now() // If 'updated_at' is null, set it to the current time.
          : DateTime.parse(map[
              'updated_at']), // Otherwise, parse the 'updated_at' string into a DateTime object.
    );
  }

  // Method to create a copy of the BlogModel with some updated fields (also used for immutability).
  BlogModel copyWith(
      {String? id, // Optional field for 'id', if null keeps the current value.
      String?
          posterId, // Optional field for 'posterId', if null keeps the current value.
      String?
          title, // Optional field for 'title', if null keeps the current value.
      String?
          content, // Optional field for 'content', if null keeps the current value.
      String?
          imageUrl, // Optional field for 'imageUrl', if null keeps the current value.
      List<String>?
          topics, // Optional field for 'topics', if null keeps the current value.
      DateTime?
          updatedAt, // Optional field for 'updatedAt', if null keeps the current value.
      String? posterName}) {
    // Optional field for 'posterName', if null keeps the current value.

    // Return a new BlogModel with the updated values or current values if not provided.
    return BlogModel(
        id: id ?? this.id,
        posterId: posterId ?? this.posterId,
        title: title ?? this.title,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics ?? this.topics,
        updatedAt: updatedAt ?? this.updatedAt,
        posterName: posterName ?? this.posterName);
  }

  // Note: The commented-out method is another way to parse JSON using the `fromJson` method, which is already implemented.
  // factory BlogModel.fromJson(String source) => Blog.fromMap(json.decode(source) as Map<String, dynamic>);
}
