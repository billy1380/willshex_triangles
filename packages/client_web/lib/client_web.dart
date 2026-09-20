library client_web;

// Embeddable pure views
export "ui/screens/welcome_screen.dart"
    show WelcomeView, WelcomeScreen, AboutView;
export "ui/screens/triangle_generator_screen.dart"
    show TriangleGeneratorView, TriangleGeneratorScreen;
export "ui/screens/settings_screen.dart" show SettingsView, SettingsScreen;

// Layout
export "ui/layout.dart" show AppLayout;

// Routes
export "package:client_common/client_common.dart" show TrianglesRoutePaths;
export "routes.dart" show TrianglesWebRoutes, Routes;

// UI & Components
export "ui/bloc_provider.dart";
export "ui/parts/interactive_viewer.dart";
export "ui/parts/palette_history_component.dart";
export "ui/parts/palette_picker_modal.dart";

// Storage
export "services/local_storage_settings_storage.dart";
