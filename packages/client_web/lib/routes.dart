import "package:jaspr_router/jaspr_router.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/screens/about_screen.dart";
import "package:client_web/ui/screens/settings_screen.dart";
import "package:client_web/ui/screens/triangle_generator_screen.dart";
import "package:client_web/ui/screens/welcome_screen.dart";

/// Route generator and helpers for Triangles web client.
class TrianglesWebRoutes {
  TrianglesWebRoutes._();

  /// Helper to convert a full path to a route-definition path.
  /// If [relative] is true, strips leading slashes and any matching [prefix].
  static String formatRoutePath(
    String fullPath, {
    String? prefix,
    bool relative = false,
  }) {
    if (!relative) return fullPath;
    var p = fullPath;
    if (prefix != null && prefix.isNotEmpty) {
      final cleanPrefix = prefix.endsWith("/")
          ? prefix.substring(0, prefix.length - 1)
          : prefix;
      if (p.startsWith(cleanPrefix)) {
        p = p.substring(cleanPrefix.length);
      }
    }
    while (p.startsWith("/")) {
      p = p.substring(1);
    }
    return p;
  }

  /// Creates a Jaspr [Route] for [WelcomeScreen].
  static Route welcomeRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.welcome,
      builder: (context, state) => WelcomeScreen(
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.palettePicker].
  static Route palettePickerRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.palettePicker,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.palettePicker,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.htmlColour].
  static Route htmlColourRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.htmlColour,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.htmlColour,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.randomPalette].
  static Route randomPaletteRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.randomPalette,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.randomPalette,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.randomGrayscale].
  static Route randomGrayscaleRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.randomGrayscale,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.randomGrayscale,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.imagePalette].
  static Route imagePaletteRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.imagePalette,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.imagePalette,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [TriangleGeneratorScreen] with [GeneratorType.imageSampler].
  static Route imageSamplerRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.imageSampler,
      builder: (context, state) => TriangleGeneratorScreen(
        generatorType: GeneratorType.imageSampler,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [SettingsScreen].
  static Route settingsRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.settings,
      builder: (context, state) => SettingsScreen(
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Creates a Jaspr [Route] for [AboutScreen].
  static Route aboutRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool useLayout = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return Route(
      path: path ?? effectivePaths.about,
      builder: (context, state) => AboutScreen(
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    );
  }

  /// Returns the list of Jaspr [Route] objects.
  ///
  /// - [prefix]: Optional URL prefix (e.g. `"/triangles"`).
  /// - [paths]: Custom route paths configuration (supports individual path overrides).
  /// - [relative]: If true, strip leading slashes for subroute mounting.
  /// - [useLayout]: When true, screens are wrapped with the standalone [AppLayout].
  ///   When false, screens render pure content (ideal when host uses its own ShellRoute).
  /// - [includeRootAlias]: If true and welcome path is not `"/"`, also adds a route for `"/"` (or prefix)
  ///   pointing to welcome.
  static List<Route> routes({
    TrianglesRoutePaths? paths,
    String? prefix,
    String basePath = "",
    bool relative = false,
    bool useLayout = true,
    bool includeRootAlias = true,
  }) {
    final effectivePrefix = prefix ?? (basePath.isNotEmpty ? basePath : null);
    var effectivePaths = paths ?? const TrianglesRoutePaths();
    if (effectivePrefix != null && effectivePrefix.isNotEmpty) {
      effectivePaths = effectivePaths.prefixed(effectivePrefix);
    }

    final welcomeRoutePath = formatRoutePath(
      effectivePaths.welcome,
      prefix: effectivePrefix,
      relative: relative,
    );

    final rootPath = relative ? "" : (effectivePrefix ?? "/");

    return [
      if (includeRootAlias && welcomeRoutePath != rootPath && welcomeRoutePath != "")
        Route(
          path: rootPath,
          builder: (context, state) => WelcomeScreen(
            useLayout: useLayout,
            paths: effectivePaths,
          ),
        ),
      welcomeRoute(
        path: welcomeRoutePath,
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      palettePickerRoute(
        path: formatRoutePath(effectivePaths.palettePicker, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      htmlColourRoute(
        path: formatRoutePath(effectivePaths.htmlColour, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      randomPaletteRoute(
        path: formatRoutePath(effectivePaths.randomPalette, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      randomGrayscaleRoute(
        path: formatRoutePath(effectivePaths.randomGrayscale, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      imagePaletteRoute(
        path: formatRoutePath(effectivePaths.imagePalette, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      imageSamplerRoute(
        path: formatRoutePath(effectivePaths.imageSampler, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      settingsRoute(
        path: formatRoutePath(effectivePaths.settings, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
      aboutRoute(
        path: formatRoutePath(effectivePaths.about, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        useLayout: useLayout,
      ),
    ];
  }
}

class Routes {
  Routes._();

  static final List<Route> routes = TrianglesWebRoutes.routes(useLayout: true);
}
