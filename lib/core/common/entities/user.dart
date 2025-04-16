// User class definition to represent the user entity
class User {
  // Declaring final variables for user details: id, name, and email
  final String id;
  final String name;
  final String email;

  // Constructor to initialize the user with id, name, and email
  User({
    required this.id, // Required field for user ID
    required this.name, // Required field for user name
    required this.email, // Required field for user email
  });
}
