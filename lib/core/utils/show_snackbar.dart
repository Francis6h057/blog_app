// Importing the Flutter Material package for widget and UI functionality.
import 'package:flutter/material.dart';

// Function to display a Snackbar with a given message.
void showSnackBar(BuildContext context, String content) {
  // Access the ScaffoldMessenger from the current BuildContext to manage SnackBars.
  ScaffoldMessenger.of(context)
    // Hide any currently displayed SnackBar before showing a new one.
    ..hideCurrentSnackBar()
    // Show a new SnackBar with the provided content (message).
    ..showSnackBar(
      SnackBar(
        // The content of the SnackBar is a Text widget displaying the given message.
        content: Text(content),
      ),
    );
}
