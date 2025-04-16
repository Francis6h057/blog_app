// Importing the Material package for using Material Design components
import 'package:flutter/material.dart';

// Defining a StatelessWidget called Loader
class Loader extends StatelessWidget {
  // Constructor of the Loader widget, passing the key to the superclass
  const Loader({super.key});

  // The build method to return the widget's UI representation
  @override
  Widget build(BuildContext context) {
    // Returning a centered CircularProgressIndicator to show loading
    return const Center(
      child: CircularProgressIndicator(), // The loading spinner widget
    );
  }
}
