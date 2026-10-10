import "package:triangles_common/constants/app_strings.dart";

/// The user's theme preference, shared by the Flutter and Web clients.
enum AppThemeMode {
  /// Follow the operating system / browser preference.
  system,
  light,
  dark;

  /// Storage key used to persist the preference.
  static const String storageKey = "themeMode";

  /// The mode used when nothing has been stored yet.
  static const AppThemeMode defaultMode = AppThemeMode.system;

  /// Parses a stored value, falling back to [defaultMode].
  static AppThemeMode fromName(String? name) {
    for (final mode in values) {
      if (mode.name == name) return mode;
    }
    return defaultMode;
  }

  String get label => switch (this) {
        AppThemeMode.system => AppStrings.themeSystem,
        AppThemeMode.light => AppStrings.themeLight,
        AppThemeMode.dark => AppStrings.themeDark,
      };

  /// Resolves this mode to a concrete brightness.
  ///
  /// [systemIsDark] is the platform preference, or `null` when it cannot be
  /// detected, in which case light is used.
  bool resolveIsDark(bool? systemIsDark) => switch (this) {
        AppThemeMode.system => systemIsDark ?? false,
        AppThemeMode.light => false,
        AppThemeMode.dark => true,
      };

  /// Cycles to the next theme mode based on platform brightness.
  ///
  /// Matches the transition cycle in willshex_embedding:
  /// - If platform is dark: `system` -> `light` -> `dark` -> `system`
  /// - If platform is light: `system` -> `dark` -> `light` -> `system`
  AppThemeMode next([bool isPlatformDark = false]) => switch (this) {
        AppThemeMode.system =>
          isPlatformDark ? AppThemeMode.light : AppThemeMode.dark,
        AppThemeMode.light =>
          isPlatformDark ? AppThemeMode.dark : AppThemeMode.system,
        AppThemeMode.dark =>
          isPlatformDark ? AppThemeMode.system : AppThemeMode.light,
      };
}
