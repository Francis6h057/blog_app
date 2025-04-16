// Importing the Flutter Material package to access Material Design colors and other UI components.
import 'package:flutter/material.dart';

// Defining a class named AppPallete that holds color constants for the application.
class AppPallete {
  // Defining a static constant for the background color using the RGB color model.
  // The color is created using the Color.fromRGBO method where RGBA stands for Red, Green, Blue, and Alpha (transparency).
  static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);

  // Defining a static constant for the first gradient color with RGB values.
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);

  // Defining a static constant for the second gradient color.
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);

  // Defining a static constant for the third gradient color.
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);

  // Defining a static constant for a border color with RGB values.
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);

  // Defining a static constant for the white color (using the predefined constant Colors.white from Flutter).
  static const Color whiteColor = Colors.white;

  // Defining a static constant for the grey color (using the predefined constant Colors.grey from Flutter).
  static const Color greyColor = Colors.grey;

  // Defining a static constant for the error color (using the predefined constant Colors.redAccent from Flutter).
  static const Color errorColor = Colors.redAccent;

  // Defining a static constant for transparent color (using the predefined constant Colors.transparent from Flutter).
  static const Color transparentColor = Colors.transparent;
}
