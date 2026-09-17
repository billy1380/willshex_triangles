/// Configuration model representing the route paths for Triangles screens.
///
/// Supports bulk prefixing, relative subroute generation (for nested GoRouter routes),
/// and individual route path overrides.
class TrianglesRoutePaths {
  static const String defaultWelcome = "/welcome";
  static const String defaultPalettePicker = "/palettepicker";
  static const String defaultHtmlColour = "/htmlcolour";
  static const String defaultRandomPalette = "/random-palette";
  static const String defaultRandomGrayscale = "/random-grayscale-palette";
  static const String defaultImagePalette = "/imagepalette";
  static const String defaultImageSampler = "/imagesamplerpalette";
  static const String defaultSettings = "/settings";
  static const String defaultAbout = "/about";

  final String welcome;
  final String palettePicker;
  final String htmlColour;
  final String randomPalette;
  final String randomGrayscale;
  final String imagePalette;
  final String imageSampler;
  final String settings;
  final String about;

  const TrianglesRoutePaths({
    this.welcome = defaultWelcome,
    this.palettePicker = defaultPalettePicker,
    this.htmlColour = defaultHtmlColour,
    this.randomPalette = defaultRandomPalette,
    this.randomGrayscale = defaultRandomGrayscale,
    this.imagePalette = defaultImagePalette,
    this.imageSampler = defaultImageSampler,
    this.settings = defaultSettings,
    this.about = defaultAbout,
  });

  static const TrianglesRoutePaths defaults = TrianglesRoutePaths();

  static String _joinPath(String prefix, String path) {
    if (prefix.isEmpty) return path;
    final cleanPrefix = prefix.endsWith("/")
        ? prefix.substring(0, prefix.length - 1)
        : prefix;
    final cleanPath = path.startsWith("/") ? path : "/$path";
    return "$cleanPrefix$cleanPath";
  }

  /// Returns a new [TrianglesRoutePaths] with [prefix] prepended to all paths.
  TrianglesRoutePaths prefixed(String prefix) {
    if (prefix.isEmpty) return this;
    return TrianglesRoutePaths(
      welcome: _joinPath(prefix, welcome),
      palettePicker: _joinPath(prefix, palettePicker),
      htmlColour: _joinPath(prefix, htmlColour),
      randomPalette: _joinPath(prefix, randomPalette),
      randomGrayscale: _joinPath(prefix, randomGrayscale),
      imagePalette: _joinPath(prefix, imagePalette),
      imageSampler: _joinPath(prefix, imageSampler),
      settings: _joinPath(prefix, settings),
      about: _joinPath(prefix, about),
    );
  }

  /// Creates a [TrianglesRoutePaths] prefixed with [prefix], with optional individual overrides.
  factory TrianglesRoutePaths.withPrefix(
    String prefix, {
    String? welcome,
    String? palettePicker,
    String? htmlColour,
    String? randomPalette,
    String? randomGrayscale,
    String? imagePalette,
    String? imageSampler,
    String? settings,
    String? about,
  }) {
    final base = TrianglesRoutePaths(
      welcome: welcome ?? defaultWelcome,
      palettePicker: palettePicker ?? defaultPalettePicker,
      htmlColour: htmlColour ?? defaultHtmlColour,
      randomPalette: randomPalette ?? defaultRandomPalette,
      randomGrayscale: randomGrayscale ?? defaultRandomGrayscale,
      imagePalette: imagePalette ?? defaultImagePalette,
      imageSampler: imageSampler ?? defaultImageSampler,
      settings: settings ?? defaultSettings,
      about: about ?? defaultAbout,
    );
    return base.prefixed(prefix);
  }

  static String _makeRelative(String path, [String? prefix]) {
    var p = path;
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

  /// Converts all paths to relative paths (stripping leading slashes and optional [prefix]).
  /// Useful when mounting routes as child routes in GoRouter.
  TrianglesRoutePaths toRelative({String? prefix}) {
    return TrianglesRoutePaths(
      welcome: _makeRelative(welcome, prefix),
      palettePicker: _makeRelative(palettePicker, prefix),
      htmlColour: _makeRelative(htmlColour, prefix),
      randomPalette: _makeRelative(randomPalette, prefix),
      randomGrayscale: _makeRelative(randomGrayscale, prefix),
      imagePalette: _makeRelative(imagePalette, prefix),
      imageSampler: _makeRelative(imageSampler, prefix),
      settings: _makeRelative(settings, prefix),
      about: _makeRelative(about, prefix),
    );
  }

  /// Returns a copy of this [TrianglesRoutePaths] with individual fields overridden.
  TrianglesRoutePaths copyWith({
    String? welcome,
    String? palettePicker,
    String? htmlColour,
    String? randomPalette,
    String? randomGrayscale,
    String? imagePalette,
    String? imageSampler,
    String? settings,
    String? about,
  }) {
    return TrianglesRoutePaths(
      welcome: welcome ?? this.welcome,
      palettePicker: palettePicker ?? this.palettePicker,
      htmlColour: htmlColour ?? this.htmlColour,
      randomPalette: randomPalette ?? this.randomPalette,
      randomGrayscale: randomGrayscale ?? this.randomGrayscale,
      imagePalette: imagePalette ?? this.imagePalette,
      imageSampler: imageSampler ?? this.imageSampler,
      settings: settings ?? this.settings,
      about: about ?? this.about,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrianglesRoutePaths &&
          runtimeType == other.runtimeType &&
          welcome == other.welcome &&
          palettePicker == other.palettePicker &&
          htmlColour == other.htmlColour &&
          randomPalette == other.randomPalette &&
          randomGrayscale == other.randomGrayscale &&
          imagePalette == other.imagePalette &&
          imageSampler == other.imageSampler &&
          settings == other.settings &&
          about == other.about;

  @override
  int get hashCode => Object.hash(
        welcome,
        palettePicker,
        htmlColour,
        randomPalette,
        randomGrayscale,
        imagePalette,
        imageSampler,
        settings,
        about,
      );

  @override
  String toString() =>
      "TrianglesRoutePaths(welcome: $welcome, palettePicker: $palettePicker, htmlColour: $htmlColour, randomPalette: $randomPalette, randomGrayscale: $randomGrayscale, imagePalette: $imagePalette, imageSampler: $imageSampler, settings: $settings, about: $about)";
}
