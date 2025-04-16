import 'package:flutter/material.dart';

// A customizable multi-line text input field for blog content or title
class BlogEditor extends StatelessWidget {
  final TextEditingController controller; // Controller to manage the input text
  final String hintText; // Placeholder text shown when the field is empty
  final double? minLength; // Optional minimum number of visible lines

  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.minLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, // Assigning the controller
      decoration: InputDecoration(
        hintText: hintText, // Showing the hint inside the field
      ),
      maxLines: null, // Allowing the input to grow vertically as needed
      minLines: minLength?.toInt() ?? 1, // Minimum visible lines in the field
      validator: (value) {
        // Validation logic to ensure field isn't left empty or whitespace only
        if (value!.trim().isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
    );
  }
}
