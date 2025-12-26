import "dart:math";

import "package:willshex_draw/willshex_draw.dart";

/// A palette that generates 3-6 random named colors
class NamedColorPalette extends Palette {
  /// Minimum distance between colors to be considered "suitable".
  /// RGB values are 0-1.
  /// Max distance (White vs Black) is sqrt(1+1+1) = ~1.73
  /// 0.4 ensures significant enough difference.
  static const double _minDistance = 0.4;
  static const int _maxRetries = 3;

  NamedColorPalette() : super("Named Colors", "named-colors") {
    // Generate between 1 and 6 colors (inclusive)
    final int count = 1 + RandomHelper.random.nextInt(6);

    final List<Color> generatedColors = [];

    for (int i = 0; i < count; i++) {
      Color candidate = NamedColorHelper.randomNamedColor;

      // Try to find a suitable color
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        if (_isSuitable(candidate, generatedColors)) {
          break;
        }
        // If not suitable, pick another random one
        candidate = NamedColorHelper.randomNamedColor;
      }

      // Add the candidate (either suitable or best effort after retries)
      generatedColors.add(candidate);
    }

    addColors(generatedColors);
  }

  /// Checks if [candidate] is suitable to be added to [existing] colors.
  bool _isSuitable(Color candidate, List<Color> existing) {
    for (final Color other in existing) {
      if (_distance(candidate, other) < _minDistance) {
        return false;
      }
    }
    return true;
  }

  /// Euclidean distance between two colors in RGB space
  double _distance(Color c1, Color c2) {
    final double dr = c1.r - c2.r;
    final double dg = c1.g - c2.g;
    final double db = c1.b - c2.b;
    return sqrt(dr * dr + dg * dg + db * db);
  }
}
