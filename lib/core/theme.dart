import 'package:flutter/material.dart';

const orange = Color(0xFFEE9236);
const ink = Color(0xFF212432);
const green = Color(0xFFA9D867);

ThemeData appTheme(bool dark) {
  final surface = dark ? ink : Colors.white;
  final foreground = dark ? Colors.white : ink;
  final muted = dark ? const Color(0xFFACADB7) : const Color(0xFF919191);
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: dark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme.fromSeed(
      seedColor: orange,
      brightness: dark ? Brightness.dark : Brightness.light,
    ).copyWith(primary: orange, surface: surface, onSurface: foreground),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.35,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: foreground,
      ),
      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: foreground,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: foreground),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: foreground),
      bodySmall: TextStyle(fontSize: 13, height: 1.5, color: muted),
    ),
    dividerColor: dark ? const Color(0xFF3A3C48) : const Color(0xFFF0F0F0),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(21),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF444653) : const Color(0xFFEAEAEA),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(21),
        borderSide: BorderSide(
          color: dark ? const Color(0xFF444653) : const Color(0xFFEAEAEA),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(21),
        borderSide: const BorderSide(color: orange),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: foreground),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: dark ? Colors.white : ink,
      contentTextStyle: TextStyle(color: dark ? ink : Colors.white),
    ),
  );
}
