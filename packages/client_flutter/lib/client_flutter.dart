library client_flutter;

// Embeddable pure views
export "pages/welcome_page.dart" show WelcomeView, WelcomePage;
export "parts/triangle_generator_page.dart"
    show TriangleGeneratorView, TriangleGeneratorPage;
export "pages/settings_page.dart" show SettingsView, SettingsPage;
export "pages/about_page.dart" show AboutView, AboutPage;

// Pages
export "pages/html_colour_page.dart";
export "pages/image_palette_page.dart";
export "pages/image_sampler_palette_page.dart";
export "pages/palette_picker_page.dart";
export "pages/random_grayscale_palette_page.dart";
export "pages/random_palette_page.dart";

// Routing
export "package:client_common/client_common.dart" show TrianglesRoutePaths;
export "routes.dart" show TrianglesRoutes, router;

// Components
export "parts/app_drawer.dart";
export "parts/palette_history.dart";
export "parts/palette_picker_dialog.dart";

// Storage services
export "services/preferences_settings_storage.dart";
