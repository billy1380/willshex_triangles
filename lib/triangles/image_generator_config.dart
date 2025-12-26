/// Palette types for color generation
enum PaletteType {
  randomNamed,
  random,
  randomGrayScale,
  commaSeparatedList;

  /// Convert enum to string for serialization
  String get name => switch (this) {
        randomNamed => "RandomNamed",
        random => "Random",
        randomGrayScale => "RandomGrayScale",
        commaSeparatedList => "CommaSeparatedList",
      };

  /// Parse string to enum
  static PaletteType fromString(String name) => switch (name) {
        "RandomNamed" => PaletteType.randomNamed,
        "Random" => PaletteType.random,
        "RandomGrayScale" => PaletteType.randomGrayScale,
        "CommaSeparatedList" => PaletteType.commaSeparatedList,
        _ => PaletteType.randomNamed, // Default fallback
      };
}

/// Configuration interface for image generation
abstract class ImageGeneratorConfig {
  // Configuration constants
  static const String formatKey = "f";
  static const String formatPng = "png";
  static const String defaultFormat = formatPng;

  static const String widthKey = "w";
  static const String heightKey = "h";
  static const int defaultWidth = 300;
  static const int defaultHeight = 300;

  static const String textureKey = "u";
  static const String? defaultTexture = null;

  static const String typeKey = "t";
  static const String defaultType = "RandomJiggle";

  static const String ratioDKey = "rd";
  static const int defaultRatioD = 12;

  static const String ratioNKey = "rn";
  static const int defaultRatioN = 1;

  static const String paletteKey = "p";
  static const String defaultPalette = "RandomNamed";

  static const String paletteColoursKey = "pc";
  static const String? defaultPaletteColours = null;

  static const String compositeKey = "c";
  static const String defaultComposite = "colorBurn";

  static const String annotateKey = "a";
  static const int defaultAnnotate = 0;

  static const String nameKey = "n";
  static const String? defaultName = null;

  static const String indexKey = "i";
  static const int defaultIndex = 0;

  static const String forceKey = "m";
  static const int defaultForce = 0;

  static const String addGameGradientsKey = "g";
  static const int defaultAddGameGradients = 0;
}
