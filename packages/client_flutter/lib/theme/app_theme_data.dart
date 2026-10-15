import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:triangles_common/client_common.dart";

/// Flutter [ThemeData] built from the shared [AppTheme] palette.
class AppThemeData {
  AppThemeData._();

  static ThemeData get light => _build(
        const ColorScheme.light(
          primary: Color(AppTheme.primaryColor),
          surface: Color(AppTheme.lightSurfaceColor),
          onSurface: Color(AppTheme.lightTextColor),
          outline: Color(AppTheme.lightBorderColor),
        ),
        background: const Color(AppTheme.lightBackgroundColor),
        mutedText: const Color(AppTheme.lightTextMutedColor),
      );

  static ThemeData get dark => _build(
        const ColorScheme.dark(
          primary: Color(AppTheme.primaryColor),
          surface: Color(AppTheme.darkSurfaceColor),
          onSurface: Color(AppTheme.darkTextColor),
          outline: Color(AppTheme.darkBorderColor),
        ),
        background: const Color(AppTheme.darkBackgroundColor),
        mutedText: const Color(AppTheme.darkTextMutedColor),
      );

  static ThemeData _build(
    ColorScheme colorScheme, {
    required Color background,
    required Color mutedText,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      useMaterial3: true,
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: mutedText,
        displayColor: mutedText,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
    );
  }

  static ThemeMode toThemeMode(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => ThemeMode.system,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
      };
}
