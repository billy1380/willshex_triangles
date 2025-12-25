/// Palette types for color generation
enum PaletteType {
  randomNamed,
  randomColourLovers,
  randomGrayScale,
  commaSeparatedList;

  /// Convert enum to string for serialization
  String get name {
    switch (this) {
      case PaletteType.randomNamed:
        return 'RandomNamed';
      case PaletteType.randomColourLovers:
        return 'RandomColourLovers';
      case PaletteType.randomGrayScale:
        return 'RandomGrayScale';
      case PaletteType.commaSeparatedList:
        return 'CommaSeparatedList';
    }
  }

  /// Parse string to enum
  static PaletteType fromString(String name) {
    switch (name) {
      case 'RandomNamed':
        return PaletteType.randomNamed;
      case 'RandomColourLovers':
        return PaletteType.randomColourLovers;
      case 'RandomGrayScale':
        return PaletteType.randomGrayScale;
      case 'CommaSeparatedList':
        return PaletteType.commaSeparatedList;
      default:
        return PaletteType.randomNamed; // Default fallback
    }
  }
}

/// Configuration interface for image generation
abstract class ImageGeneratorConfig {
  // Configuration constants
  static const String formatKey = 'f';
  static const String formatPng = 'png';
  static const String defaultFormat = formatPng;

  static const String widthKey = 'w';
  static const String heightKey = 'h';
  static const int defaultWidth = 300;
  static const int defaultHeight = 300;

  static const String textureKey = 'u';
  static const String? defaultTexture = null;

  static const String typeKey = 't';
  static const String defaultType = 'RandomJiggle';

  static const String ratioDKey = 'rd';
  static const int defaultRatioD = 12;

  static const String ratioNKey = 'rn';
  static const int defaultRatioN = 1;

  static const String paletteKey = 'p';
  static const String defaultPalette = 'RandomNamed';

  static const String paletteColoursKey = 'pc';
  static const String? defaultPaletteColours = null;

  static const String compositeKey = 'c';
  static const String defaultComposite = 'ColorBurn';

  static const String annotateKey = 'a';
  static const int defaultAnnotate = 0;

  static const String nameKey = 'n';
  static const String? defaultName = null;

  static const String indexKey = 'i';
  static const int defaultIndex = 0;

  static const String forceKey = 'm';
  static const int defaultForce = 0;
}
