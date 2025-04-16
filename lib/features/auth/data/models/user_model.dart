// Import the base User class to extend it in UserModel
import 'package:blog_app/core/common/entities/user.dart';

// UserModel class extends the base User class to include more specific user-related logic
class UserModel extends User {
  // Constructor that takes id, name, and email parameters and passes them to the superclass (User)
  UserModel({
    required super.id,
    required super.name,
    required super.email,
  });

  // Factory constructor that creates a UserModel instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> map) {
    // Safely extract values from the map, providing defaults if not present
    return UserModel(
      id: map['id'] ?? '', // Default empty string if 'id' is missing
      name: map['name'] ?? '', // Default empty string if 'name' is missing
      email: map['email'] ?? '', // Default empty string if 'email' is missing
    );
  }

  // Method to create a copy of the UserModel with updated values, if any
  UserModel copyWith({
    String? id, // Optional parameter for id, falls back to existing if null
    String? name, // Optional parameter for name, falls back to existing if null
    String?
        email, // Optional parameter for email, falls back to existing if null
  }) {
    // Returns a new UserModel with the new values or existing values if not provided
    return UserModel(
      id: id ?? this.id, // If id is provided, use it; otherwise, use current id
      name: name ??
          this.name, // If name is provided, use it; otherwise, use current name
      email: email ??
          this.email, // If email is provided, use it; otherwise, use current email
    );
  }
}
