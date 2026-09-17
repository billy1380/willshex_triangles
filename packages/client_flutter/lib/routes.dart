import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/pages/welcome_page.dart";
import "package:client_flutter/pages/html_colour_page.dart";
import "package:client_flutter/pages/random_palette_page.dart";
import "package:client_flutter/pages/random_grayscale_palette_page.dart";
import "package:client_flutter/pages/image_palette_page.dart";
import "package:client_flutter/pages/image_sampler_palette_page.dart";
import "package:client_flutter/pages/settings_page.dart";
import "package:client_flutter/pages/about_page.dart";
import "package:client_flutter/pages/palette_picker_page.dart";

/// Route definitions and helpers for Triangles in Flutter.
class TrianglesRoutes {
  TrianglesRoutes._();

  /// Helper to convert a full path to a route-definition path.
  /// If [relative] is true, strips leading slashes and any matching [prefix],
  /// which is required when mounting routes under a parent [GoRoute].
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

  /// Creates a [GoRoute] for [WelcomePage].
  static GoRoute welcomeRoute({
    String? path,
    TrianglesRoutePaths? paths,
    String? assetPackage,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "WelcomePage",
      path: path ?? effectivePaths.welcome,
      builder: (context, state) => WelcomePage(
        paths: effectivePaths,
        assetPackage: assetPackage,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [PalettePickerPage].
  static GoRoute palettePickerRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "PalettePickerPage",
      path: path ?? effectivePaths.palettePicker,
      builder: (context, state) => PalettePickerPage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [HtmlColourPage].
  static GoRoute htmlColourRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "HtmlColourPage",
      path: path ?? effectivePaths.htmlColour,
      builder: (context, state) => HtmlColourPage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [RandomPalettePage].
  static GoRoute randomPaletteRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "RandomPalettePage",
      path: path ?? effectivePaths.randomPalette,
      builder: (context, state) => RandomPalettePage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [RandomGrayscalePalettePage].
  static GoRoute randomGrayscaleRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "RandomGrayscalePalettePage",
      path: path ?? effectivePaths.randomGrayscale,
      builder: (context, state) => RandomGrayscalePalettePage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [ImagePalettePage].
  static GoRoute imagePaletteRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "ImagePalettePage",
      path: path ?? effectivePaths.imagePalette,
      builder: (context, state) => ImagePalettePage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [ImageSamplerPalettePage].
  static GoRoute imageSamplerRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "ImageSamplerPalettePage",
      path: path ?? effectivePaths.imageSampler,
      builder: (context, state) => ImageSamplerPalettePage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [SettingsPage].
  static GoRoute settingsRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "SettingsPage",
      path: path ?? effectivePaths.settings,
      builder: (context, state) => SettingsPage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Creates a [GoRoute] for [AboutPage].
  static GoRoute aboutRoute({
    String? path,
    TrianglesRoutePaths? paths,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePaths = paths ?? const TrianglesRoutePaths();
    return GoRoute(
      name: "AboutPage",
      path: path ?? effectivePaths.about,
      builder: (context, state) => AboutPage(
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    );
  }

  /// Returns the complete list of [RouteBase] for integration into [GoRouter].
  ///
  /// - [prefix]: Optional URL prefix (e.g. `"/triangles"`).
  /// - [paths]: Custom route paths configuration (supports individual path overrides).
  /// - [relative]: If true, strip leading slashes so routes can be mounted as subroutes
  ///   under a parent [GoRoute(path: '/triangles', routes: [...])].
  /// - [showDrawer]: Whether pages should render the standalone [AppDrawer].
  /// - [showAppBar]: Whether pages should render their own [AppBar].
  static List<RouteBase> routes({
    TrianglesRoutePaths? paths,
    String? prefix,
    String basePath = "",
    String? assetPackage,
    bool relative = false,
    bool showDrawer = false,
    bool showAppBar = true,
  }) {
    final effectivePrefix = prefix ?? (basePath.isNotEmpty ? basePath : null);
    var effectivePaths = paths ?? const TrianglesRoutePaths();
    if (effectivePrefix != null && effectivePrefix.isNotEmpty) {
      effectivePaths = effectivePaths.prefixed(effectivePrefix);
    }

    return [
      welcomeRoute(
        path: formatRoutePath(effectivePaths.welcome, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        assetPackage: assetPackage,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      palettePickerRoute(
        path: formatRoutePath(effectivePaths.palettePicker, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      htmlColourRoute(
        path: formatRoutePath(effectivePaths.htmlColour, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      randomPaletteRoute(
        path: formatRoutePath(effectivePaths.randomPalette, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      randomGrayscaleRoute(
        path: formatRoutePath(effectivePaths.randomGrayscale, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      imagePaletteRoute(
        path: formatRoutePath(effectivePaths.imagePalette, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      imageSamplerRoute(
        path: formatRoutePath(effectivePaths.imageSampler, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      settingsRoute(
        path: formatRoutePath(effectivePaths.settings, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
      aboutRoute(
        path: formatRoutePath(effectivePaths.about, prefix: effectivePrefix, relative: relative),
        paths: effectivePaths,
        showDrawer: showDrawer,
        showAppBar: showAppBar,
      ),
    ];
  }
}

final GoRouter router = GoRouter(
  initialLocation: WelcomePage.routePath,
  routes: TrianglesRoutes.routes(
    showDrawer: true,
    showAppBar: true,
  ),
);
