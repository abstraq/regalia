import "package:flutter/material.dart";
import "package:regalia/core/presentation/shadows.dart";

class DefaultTheme {
  const DefaultTheme._();

  static const String fontFamily = "Lato";
  static const Color primaryColor = Color(0xFF18643E);
  static const Color foregroundColor = Color(0xFFF4F4F4);
  static const Color backgroundColor = Color(0xFF212121);

  static const TextTheme textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 48,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 34,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      shadows: [AppShadows.darkElevation01],
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: primaryColor,
    onPrimary: foregroundColor,
    background: backgroundColor,
    onBackground: foregroundColor,
    surface: backgroundColor,
    onSurface: foregroundColor,
  );

  static ThemeData darkTheme = ThemeData.from(colorScheme: darkColorScheme, textTheme: textTheme, useMaterial3: true);
}
