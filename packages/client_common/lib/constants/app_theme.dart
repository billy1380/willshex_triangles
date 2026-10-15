class AppTheme {
  // Primary
  static const int primaryColor = 0xFF41C2C2;
  static const int primaryHoverColor = 0xFF35A4A4;

  // Dark Theme
  static const int darkBackgroundColor = 0xFF0F172A; // Scaffold Background
  static const int darkSurfaceColor = 0xFF1E293B; // Card / Sidebar
  static const int darkBorderColor = 0xFF334155;
  static const int darkTextColor = 0xFFF8FAFC; // On Surface
  static const int darkTextMutedColor = 0xFF94A3B8; // Muted text

  // Light Theme
  static const int lightBackgroundColor = 0xFFF8FAFC;
  static const int lightSurfaceColor = 0xFFFFFFFF;
  static const int lightBorderColor = 0xFFE2E8F0;
  static const int lightTextColor = 0xFF0F172A;
  static const int lightTextMutedColor = 0xFF64748B;
  
  static String toHex(int color) {
    return '#${(color & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }

  static String toRgb(int color) {
    final r = (color >> 16) & 0xFF;
    final g = (color >> 8) & 0xFF;
    final b = color & 0xFF;
    return "$r, $g, $b";
  }

  static String get cssVars => '''
:root, [data-bs-theme="light"], [data-bs-theme="dark"] {
  --app-font: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --heading-font: 'Outfit', sans-serif;
  --bs-primary: ${toHex(primaryColor)};
  --bs-primary-rgb: ${toRgb(primaryColor)};
  --bs-primary-hover: ${toHex(primaryHoverColor)};
  --primary-color: var(--bs-primary);
  --primary-hover: var(--bs-primary-hover);
  --bs-link-color: var(--bs-primary);
  --bs-link-color-rgb: ${toRgb(primaryColor)};
  --bs-link-hover-color: var(--bs-primary-hover);
  --bs-focus-ring-color: rgba(${toRgb(primaryColor)}, 0.25);
  --bs-primary-bg-subtle: rgba(${toRgb(primaryColor)}, 0.15);
  --bs-primary-border-subtle: rgba(${toRgb(primaryColor)}, 0.35);
}

:root, [data-bs-theme="light"] {
  --bs-body-bg: ${toHex(lightBackgroundColor)};
  --bs-card-bg: ${toHex(lightSurfaceColor)};
  --bs-border-color: ${toHex(lightBorderColor)};
  --bs-body-color: ${toHex(lightTextColor)};
  --bs-secondary-color: ${toHex(lightTextMutedColor)};
  --bs-tertiary-bg: #f1f5f9;

  --bg-color: var(--bs-body-bg);
  --card-bg: var(--bs-card-bg);
  --sidebar-bg: var(--bs-card-bg);
  --border-color: var(--bs-border-color);
  --text-main: var(--bs-body-color);
  --text-muted: var(--bs-secondary-color);
}

[data-bs-theme="dark"] {
  --bs-body-bg: ${toHex(darkBackgroundColor)};
  --bs-card-bg: ${toHex(darkSurfaceColor)};
  --bs-border-color: ${toHex(darkBorderColor)};
  --bs-body-color: ${toHex(darkTextColor)};
  --bs-secondary-color: ${toHex(darkTextMutedColor)};
  --bs-tertiary-bg: ${toHex(darkSurfaceColor)};

  --bg-color: var(--bs-body-bg);
  --card-bg: var(--bs-card-bg);
  --sidebar-bg: var(--bs-card-bg);
  --border-color: var(--bs-border-color);
  --text-main: var(--bs-body-color);
  --text-muted: var(--bs-secondary-color);
  --bs-primary-bg-subtle: rgba(${toRgb(primaryColor)}, 0.2);
  --bs-primary-border-subtle: rgba(${toRgb(primaryColor)}, 0.45);
}
''';
}
