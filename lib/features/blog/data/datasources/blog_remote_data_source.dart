// Importing necessary libraries for file handling and Supabase client interaction.
import 'dart:io';
import 'package:blog_app/core/error/exceptions.dart'; // For handling server exceptions.
import 'package:blog_app/features/blog/data/models/blog_model.dart'; // For BlogModel class to map data.
import 'package:supabase_flutter/supabase_flutter.dart'; // For interacting with Supabase.

/// The abstract interface class for BlogRemoteDataSource defining methods for blog and image operations.
abstract interface class BlogRemoteDataSource {
  // Method for uploading a blog to the remote server.
  Future<BlogModel> uploadBlog(BlogModel blog);

  // Method for uploading a blog's image to remote storage.
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });

  // Method for fetching all blogs from the remote server.
  Future<List<BlogModel>> getAllBlogs();
}

/// The implementation of BlogRemoteDataSource using Supabase as the backend.
class BlogRemoteDatasourceImpl implements BlogRemoteDataSource {
  // The Supabase client for making database and storage requests.
  final SupabaseClient supabaseClient;

  // Constructor that initializes the Supabase client.
  BlogRemoteDatasourceImpl({required this.supabaseClient});

  // Method to upload a blog to Supabase.
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      // Insert the blog into the 'blogs' table in Supabase and retrieve the inserted data.
      final blogData = await supabaseClient
          .from('blogs') // Specify the 'blogs' table.
          .insert(
            blog.toJson(), // Convert the BlogModel instance to JSON for insertion.
          )
          .select(); // Select the inserted row.

      // Return the BlogModel instance after parsing the data.
      return BlogModel.fromJson(
          blogData.first); // Convert the first result to a BlogModel.
    } catch (e) {
      // If an error occurs, throw a custom ServerException with the error message.
      throw ServerException(e.toString());
    }
  }

  // Method to upload the blog image to Supabase storage.
  @override
  Future<String> uploadBlogImage({
    required File image, // The image file to upload.
    required BlogModel blog, // The blog associated with the image.
  }) async {
    try {
      // Upload the image to the 'blog_images' storage bucket in Supabase.
      await supabaseClient.storage.from('blog_images').upload(
            blog.id, // Use the blog's ID as the filename.
            image, // The image file being uploaded.
          );

      // Retrieve the public URL of the uploaded image.
      return supabaseClient.storage
          .from(
            'blog_images', // Specify the storage bucket for blog images.
          )
          .getPublicUrl(
            blog.id, // Use the blog's ID to get the URL for the uploaded image.
          );
    } catch (e) {
      // If an error occurs, throw a custom ServerException with the error message.
      throw ServerException(e.toString());
    }
  }

  // Method to fetch all blogs from Supabase.
  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // Fetch all blogs from the 'blogs' table, along with the associated 'profiles' (poster name).
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');

      // Map over the results, converting each blog data to BlogModel and associating poster name.
      return blogs
          .map(
            (blog) => BlogModel.fromJson(blog).copyWith(
              posterName: blog['profiles']
                  ['name'], // Set the poster's name from the profile data.
            ),
          )
          .toList(); // Return a list of BlogModel instances with poster names.
    } catch (e) {
      // If an error occurs, throw a custom ServerException with the error message.
      throw ServerException(e.toString());
    }
  }
}
