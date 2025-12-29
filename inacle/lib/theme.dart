import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color primaryLightColor = Color(0xFF7986CB);
  static const Color primaryDarkColor = Color(0xFF303F9F);
  static const Color secondaryColor = Color(0xFFFF4081);
  static const Color secondaryLightColor = Color(0xFFFF80AB);
  static const Color secondaryDarkColor = Color(0xFFC51162);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: primaryColor,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: primaryDarkColor,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: primaryLightColor,
      secondary: secondaryLightColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );
}
