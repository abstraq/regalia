import "package:flutter/material.dart";
import "package:regalia/core/presentation/shadows.dart";

class DefaultTheme {
  const DefaultTheme._();

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(fontFamily: "Lato", fontSize: 48, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontFamily: "Lato", fontSize: 34, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontFamily: "Lato", fontSize: 34, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(fontFamily: "Lato", fontSize: 24, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(fontFamily: "Lato", fontSize: 16, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontFamily: "Lato", fontSize: 18, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontFamily: "Lato", fontSize: 16, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
      fontFamily: "Lato",
      fontSize: 14,
      fontWeight: FontWeight.w400,
      shadows: [AppShadows.darkElevation01],
    ),
    labelLarge: TextStyle(fontFamily: "Lato", fontSize: 12, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontFamily: "Lato", fontSize: 11, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(fontFamily: "Lato", fontSize: 10, fontWeight: FontWeight.w400),
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: Color.fromARGB(255, 218, 0, 55),
    onPrimary: Color.fromARGB(255, 237, 237, 237),
    background: Color.fromARGB(255, 50, 50, 50),
    onBackground: Color.fromARGB(255, 237, 237, 237),
    surface: Color.fromARGB(255, 40, 40, 40),
    onSurface: Color.fromARGB(255, 237, 237, 237),
  );

  static ThemeData darkTheme = ThemeData.from(colorScheme: darkColorScheme, textTheme: textTheme, useMaterial3: true);
}
