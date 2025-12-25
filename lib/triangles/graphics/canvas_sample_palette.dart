import "package:willshex_draw/willshex_draw.dart";

import "color_cut_quantizer.dart";
import "color_utils.dart";

/// A helper class to extract prominent colors from an image
class CanvasSamplePalette extends Palette {
  static const int _defaultCalculateNumberColors = 16;

  static const double _targetDarkLuma = 0.26;
  static const double _maxDarkLuma = 0.45;

  static const double _minLightLuma = 0.55;
  static const double _targetLightLuma = 0.74;

  static const double _minNormalLuma = 0.3;
  static const double _targetNormalLuma = 0.5;
  static const double _maxNormalLuma = 0.7;

  static const double _targetMutedSaturation = 0.3;
  static const double _maxMutedSaturation = 0.4;

  static const double _targetVibrantSaturation = 1.0;
  static const double _minVibrantSaturation = 0.35;

  final Map<int, int> _populations;

  Color? _vibrantColor;
  Color? _mutedColor;
  Color? _darkVibrantColor;
  Color? _darkMutedColor;
  Color? _lightVibrantColor;
  Color? _lightMutedColor;

  /// Generate a CanvasSamplePalette from pixel data using the default number of colors
  static CanvasSamplePalette generate(List<int> pixels) {
    return generateWithColors(pixels, _defaultCalculateNumberColors);
  }

  /// Generate a CanvasSamplePalette from pixel data using the specified number of colors
  static CanvasSamplePalette generateWithColors(
      List<int> pixels, int numColors) {
    if (numColors < 1) {
      throw ArgumentError("numColors must be 1 or greater");
    }

    // Now generate a quantizer from the pixel data
    final ColorCutQuantizer quantizer =
        ColorCutQuantizer.fromPixels(pixels, numColors);

    // Now return a CanvasSamplePalette instance
    return CanvasSamplePalette._(
      quantizer.quantizedColors,
      quantizer.quantizedColorPopulations,
    );
  }

  /// Private constructor
  CanvasSamplePalette._(List<Color> colors, Map<int, int> populations)
      : _populations = populations {
    // Add colors to the parent palette
    addColors(colors);

    final int highestPopulation = _findMaxPopulation();

    _vibrantColor = _findColor(
      _targetNormalLuma,
      _minNormalLuma,
      _maxNormalLuma,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _lightVibrantColor = _findColor(
      _targetLightLuma,
      _minLightLuma,
      1.0,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _darkVibrantColor = _findColor(
      _targetDarkLuma,
      0.0,
      _maxDarkLuma,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _mutedColor = _findColor(
      _targetNormalLuma,
      _minNormalLuma,
      _maxNormalLuma,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );

    _lightMutedColor = _findColor(
      _targetLightLuma,
      _minLightLuma,
      1.0,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );

    _darkMutedColor = _findColor(
      _targetDarkLuma,
      0.0,
      _maxDarkLuma,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );

    // Now try and generate any missing colors
    _generateEmptyColors(highestPopulation);
  }

  /// Returns the most vibrant color in the palette
  Color? get vibrantColor => _vibrantColor;

  /// Returns a light and vibrant color from the palette
  Color? get lightVibrantColor => _lightVibrantColor;

  /// Returns a dark and vibrant color from the palette
  Color? get darkVibrantColor => _darkVibrantColor;

  /// Returns a muted color from the palette
  Color? get mutedColor => _mutedColor;

  /// Returns a muted and light color from the palette
  Color? get lightMutedColor => _lightMutedColor;

  /// Returns a muted and dark color from the palette
  Color? get darkMutedColor => _darkMutedColor;

  /// Returns the most vibrant color in the palette with a default fallback
  Color getVibrantColor(Color defaultColor) {
    return _vibrantColor ?? defaultColor;
  }

  /// Returns a light and vibrant color from the palette with a default fallback
  Color getLightVibrantColor(Color defaultColor) {
    return _lightVibrantColor ?? defaultColor;
  }

  /// Returns a dark and vibrant color from the palette with a default fallback
  Color getDarkVibrantColor(Color defaultColor) {
    return _darkVibrantColor ?? defaultColor;
  }

  /// Returns a muted color from the palette with a default fallback
  Color getMutedColor(Color defaultColor) {
    return _mutedColor ?? defaultColor;
  }

  /// Returns a muted and light color from the palette with a default fallback
  Color getLightMutedColor(Color defaultColor) {
    return _lightMutedColor ?? defaultColor;
  }

  /// Returns a muted and dark color from the palette with a default fallback
  Color getDarkMutedColor(Color defaultColor) {
    return _darkMutedColor ?? defaultColor;
  }

  /// Check if a color is already selected
  bool _isAlreadySelected(Color color) {
    return _vibrantColor == color ||
        _darkVibrantColor == color ||
        _lightVibrantColor == color ||
        _mutedColor == color ||
        _darkMutedColor == color ||
        _lightMutedColor == color;
  }

  /// Find a color that matches the specified criteria
  Color? _findColor(
    double targetLuma,
    double minLuma,
    double maxLuma,
    double targetSaturation,
    double minSaturation,
    double maxSaturation,
    int highestPopulation,
  ) {
    Color? bestColor;
    double bestScore = 0.0;

    for (final Color color in colors) {
      final double saturation = ColorUtils.saturation(_colorToInt(color));
      final double luma = ColorUtils.calculateXyzLuma(_colorToInt(color));

      if (saturation >= minSaturation &&
          saturation <= maxSaturation &&
          luma >= minLuma &&
          luma <= maxLuma &&
          !_isAlreadySelected(color)) {
        final double score = _createComparisonValue(
          saturation,
          targetSaturation,
          luma,
          targetLuma,
          _getPopulation(color),
          highestPopulation,
        );
        if (score > bestScore) {
          bestScore = score;
          bestColor = color;
        }
      }
    }

    return bestColor;
  }

  /// Generate empty colors by finding the best available colors
  void _generateEmptyColors(int highestPopulation) {
    _vibrantColor ??= _findColor(
      _targetNormalLuma,
      _minNormalLuma,
      _maxNormalLuma,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _lightVibrantColor ??= _findColor(
      _targetLightLuma,
      _minLightLuma,
      1.0,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _darkVibrantColor ??= _findColor(
      _targetDarkLuma,
      0.0,
      _maxDarkLuma,
      _targetVibrantSaturation,
      _minVibrantSaturation,
      1.0,
      highestPopulation,
    );

    _mutedColor ??= _findColor(
      _targetNormalLuma,
      _minNormalLuma,
      _maxNormalLuma,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );

    _lightMutedColor ??= _findColor(
      _targetLightLuma,
      _minLightLuma,
      1.0,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );

    _darkMutedColor ??= _findColor(
      _targetDarkLuma,
      0.0,
      _maxDarkLuma,
      _targetMutedSaturation,
      0.0,
      _maxMutedSaturation,
      highestPopulation,
    );
  }

  /// Find the maximum population among all colors
  int _findMaxPopulation() {
    int maxPopulation = 0;
    for (final Color color in colors) {
      final int population = _getPopulation(color);
      if (population > maxPopulation) {
        maxPopulation = population;
      }
    }
    return maxPopulation;
  }

  /// Get the population of a color
  int _getPopulation(Color color) {
    final int colorInt = _colorToInt(color);
    return _populations[colorInt] ?? 1;
  }

  /// Convert Color object to int representation
  int _colorToInt(Color color) {
    return ColorUtils.argb(
      (color.alpha * 255).round(),
      (color.red * 255).round(),
      (color.green * 255).round(),
      (color.blue * 255).round(),
    );
  }

  /// Create a comparison value for color selection
  static double _createComparisonValue(
    double saturation,
    double targetSaturation,
    double luma,
    double targetLuma,
    int population,
    int highestPopulation,
  ) {
    return _weightedMean([
      _invertDiff(saturation, targetSaturation) * 3.0,
      3.0,
      _invertDiff(luma, targetLuma) * 6.0,
      6.0,
      population / highestPopulation,
      1.0,
    ]);
  }

  /// Invert the difference between two values
  static double _invertDiff(double value, double targetValue) {
    return 1.0 - (value - targetValue).abs();
  }

  /// Calculate weighted mean of values
  static double _weightedMean(List<double> values) {
    double sum = 0.0;
    double sumWeight = 0.0;

    for (int i = 0; i < values.length; i += 2) {
      final double value = values[i];
      final double weight = values[i + 1];
      sum += value * weight;
      sumWeight += weight;
    }

    return sum / sumWeight;
  }
}
