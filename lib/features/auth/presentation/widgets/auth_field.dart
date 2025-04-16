import 'package:flutter/material.dart'; // Flutter material package

// Custom AuthField widget for authentication forms
class AuthField extends StatelessWidget {
  final String
      hintText; // The hint text to show in the input field (e.g., 'Email', 'Password')
  final TextEditingController controller; // Controller to manage the text input
  final bool
      obscureText; // Whether the text should be obscured (e.g., for password)

  // Constructor for initializing the AuthField widget
  const AuthField({
    super.key,
    required this.hintText, // Hint text passed in the constructor
    required this.controller, // Text controller passed in the constructor
    this.obscureText =
        false, // Default value for obscureText is false (not obscured)
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText, // Display the hint text in the input field
      ),
      obscureText:
          obscureText, // Obscure the text if true (typically for passwords)
      controller: controller, // Use the passed controller to manage text input
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$hintText cannot be empty'; // Show error message if the field is empty
        }
        return null; // Return null if input is valid
      },
    );
  }
}
