// Importing the AppPallete class to access the color constants.
import 'package:blog_app/core/theme/app_pallete.dart';
// Importing the Flutter Material package to access the ThemeData and other UI components.
import 'package:flutter/material.dart';

// Defining a class named AppTheme to centralize the app's theme configuration.
class AppTheme {
  // Defining a static method _border that creates an OutlineInputBorder with a specified color.
  // The color defaults to AppPallete.borderColor if no color is provided.
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color, // Setting the color of the border
        width: 4, // Setting the width of the border
      ),
      borderRadius:
          BorderRadius.circular(12) // Giving the border rounded corners
      );

  // Defining a static final variable darkThemeMode which holds the dark theme configuration.
  static final darkThemeMode = ThemeData.dark().copyWith(
    // Customizing the scaffold background color using the backgroundColor from AppPallete.
    scaffoldBackgroundColor: AppPallete.backgroundColor,

    // Customizing the app bar theme to have a background color from AppPallete.
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.borderColor,
    ),

    // Customizing the chip theme to use the background color from AppPallete.
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(AppPallete.backgroundColor),
      side: BorderSide.none, // Removing the border for chips
    ),

    // Customizing the input decoration theme for form fields like text fields.
    inputDecorationTheme: InputDecorationTheme(
      contentPadding:
          const EdgeInsets.all(28), // Padding inside the input fields

      // Setting the border for enabled state (default state) of input fields.
      enabledBorder: _border(),

      // Setting the border for the error state of input fields.
      errorBorder: _border(AppPallete.errorColor),

      // Setting the border for the focused state of input fields (when the field is selected).
      focusedBorder: _border(AppPallete.gradient2),

      // Setting the default border for input fields (when no error and not focused).
      border: _border(),
    ),
  );
}
