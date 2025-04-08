import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 4,
      ),
      borderRadius: BorderRadius.circular(12));
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.borderColor,
    ),
    chipTheme: const ChipThemeData(
      color: WidgetStatePropertyAll(
        AppPallete.backgroundColor,
      ),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(28),
      enabledBorder: _border(),
      errorBorder: _border(AppPallete.errorColor),
      focusedBorder: _border(AppPallete.gradient2),
      focusedErrorBorder: _border(AppPallete.errorColor),
    ),
  );
}
