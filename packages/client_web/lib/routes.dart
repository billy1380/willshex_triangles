import "package:jaspr_router/jaspr_router.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/screens/about_screen.dart";
import "package:client_web/ui/screens/settings_screen.dart";
import "package:client_web/ui/screens/triangle_generator_screen.dart";
import "package:client_web/ui/screens/welcome_screen.dart";

class Routes {
  Routes._();

  static final List<Route> routes = [
    Route(
      path: "/",
      builder: (context, state) => const WelcomeScreen(),
    ),
    Route(
      path: "/welcome",
      builder: (context, state) => const WelcomeScreen(),
    ),
    Route(
      path: "/palettepicker",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.palettePicker,
      ),
    ),
    Route(
      path: "/htmlcolour",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.htmlColour,
      ),
    ),
    Route(
      path: "/random-palette",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.randomPalette,
      ),
    ),
    Route(
      path: "/random-grayscale-palette",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.randomGrayscale,
      ),
    ),
    Route(
      path: "/imagepalette",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.imagePalette,
      ),
    ),
    Route(
      path: "/imagesamplerpalette",
      builder: (context, state) => const TriangleGeneratorScreen(
        generatorType: GeneratorType.imageSampler,
      ),
    ),
    Route(
      path: "/settings",
      builder: (context, state) => const SettingsScreen(),
    ),
    Route(
      path: "/about",
      builder: (context, state) => const AboutScreen(),
    ),
  ];
}
