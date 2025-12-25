import "dart:math" as math;
import "package:willshex_draw/willshex_draw.dart";
import "color_utils.dart";
import "color_histogram.dart";

/// Vbox class for representing a color box in the quantizer
class Vbox {
  int lowerIndex;
  int upperIndex;
  late int minRed, maxRed;
  late int minGreen, maxGreen;
  late int minBlue, maxBlue;

  final List<int> _colors;
  final Map<int, int> _colorPopulations;

  Vbox(this.lowerIndex, this.upperIndex, this._colors, this._colorPopulations) {
    fitBox();
  }

  /// Get the volume of this box
  int get volume =>
      (maxRed - minRed + 1) *
      (maxGreen - minGreen + 1) *
      (maxBlue - minBlue + 1);

  /// Check if this box can be split
  bool get canSplit => colorCount > 1;

  /// Get the number of colors in this box
  int get colorCount => upperIndex - lowerIndex + 1;

  /// Fit the box to the colors it contains
  void fitBox() {
    minRed = minGreen = minBlue = 255;
    maxRed = maxGreen = maxBlue = 0;

    for (int i = lowerIndex; i <= upperIndex; i++) {
      final int color = _colors[i];
      minRed = math.min(minRed, ColorUtils.red(color));
      maxRed = math.max(maxRed, ColorUtils.red(color));
      minGreen = math.min(minGreen, ColorUtils.green(color));
      maxGreen = math.max(maxGreen, ColorUtils.green(color));
      minBlue = math.min(minBlue, ColorUtils.blue(color));
      maxBlue = math.max(maxBlue, ColorUtils.blue(color));
    }
  }

  /// Split this box into two boxes
  Vbox splitBox() {
    if (!canSplit) {
      throw StateError("Can not split a box with only 1 color");
    }

    // Find the longest dimension
    final int longestDimension = _getLongestColorDimension();

    // Modify the box to have the upper half of the longest dimension
    final int median = _findSplitPoint(longestDimension);
    final Vbox newBox =
        Vbox(median + 1, upperIndex, _colors, _colorPopulations);

    // Now modify this current box's upper index and recompute the color boundaries
    upperIndex = median;
    fitBox();

    return newBox;
  }

  /// Get the longest color dimension
  int _getLongestColorDimension() {
    final int redLength = maxRed - minRed;
    final int greenLength = maxGreen - minGreen;
    final int blueLength = maxBlue - minBlue;

    if (redLength >= greenLength && redLength >= blueLength) {
      return -3; // _componentRed
    } else if (greenLength >= redLength && greenLength >= blueLength) {
      return -2; // _componentGreen
    } else {
      return -1; // _componentBlue
    }
  }

  /// Find the split point for the given dimension
  int _findSplitPoint(int dimension) {
    // Sort the colors in this box by the given dimension
    final List<int> colors = _colors.sublist(lowerIndex, upperIndex + 1);
    colors.sort((a, b) {
      switch (dimension) {
        case -3: // _componentRed
          return ColorUtils.red(a).compareTo(ColorUtils.red(b));
        case -2: // _componentGreen
          return ColorUtils.green(a).compareTo(ColorUtils.green(b));
        case -1: // _componentBlue
          return ColorUtils.blue(a).compareTo(ColorUtils.blue(b));
        default:
          return 0;
      }
    });

    // Find the median
    return lowerIndex + (colors.length ~/ 2);
  }

  /// Get the average color of this box
  Color get averageColor {
    int redSum = 0, greenSum = 0, blueSum = 0, totalPopulation = 0;

    for (int i = lowerIndex; i <= upperIndex; i++) {
      final int color = _colors[i];
      final int population = _colorPopulations[color] ?? 1;

      redSum += ColorUtils.red(color) * population;
      greenSum += ColorUtils.green(color) * population;
      blueSum += ColorUtils.blue(color) * population;
      totalPopulation += population;
    }

    final int redAverage = (redSum / totalPopulation).round();
    final int greenAverage = (greenSum / totalPopulation).round();
    final int blueAverage = (blueSum / totalPopulation).round();

    return Color.rgbaColor(
      redAverage / 255.0,
      greenAverage / 255.0,
      blueAverage / 255.0,
    );
  }
}

/// A color quantizer based on the Median-cut algorithm, optimized for picking out distinct colors
/// rather than representative colors.
class ColorCutQuantizer {
  static const double _blackMaxLightness = 0.05;
  static const double _whiteMinLightness = 0.95;

  final List<int> _colors;
  final Map<int, int> _colorPopulations;
  final List<Color> _quantizedColors;
  final Map<int, int> _quantizedColorPopulations = <int, int>{};

  /// Factory method to generate a ColorCutQuantizer from pixel data
  static ColorCutQuantizer fromPixels(List<int> pixels, int maxColors) {
    return ColorCutQuantizer._(ColorHistogram(pixels), maxColors);
  }

  /// Private constructor
  ColorCutQuantizer._(ColorHistogram colorHistogram, int maxColors)
      : _colors = <int>[],
        _colorPopulations = <int, int>{},
        _quantizedColors = <Color>[] {
    if (maxColors < 1) {
      throw ArgumentError("maxColors must be 1 or greater");
    }

    final int rawColorCount = colorHistogram.numberOfColors;
    final List<int> rawColors = colorHistogram.colors;
    final List<int> rawColorCounts = colorHistogram.colorCounts;

    // First, pack the populations into a map so they can be easily retrieved
    for (int i = 0; i < rawColors.length; i++) {
      _colorPopulations[rawColors[i]] = rawColorCounts[i];
    }

    // Now go through all of the colors and keep those which we do not want to ignore
    _colors.length = rawColorCount;
    int validColorCount = 0;
    for (int color in rawColors) {
      if (!_shouldIgnoreColorInt(color)) {
        _colors[validColorCount++] = color;
      }
    }

    if (validColorCount <= maxColors) {
      // The image has fewer colors than the maximum requested, so just return the colors
      for (final int color in _colors.take(validColorCount)) {
        _quantizedColors.add(Color.rgbaColor(
          ColorUtils.red(color) / 255.0,
          ColorUtils.green(color) / 255.0,
          ColorUtils.blue(color) / 255.0,
        ));
        _quantizedColorPopulations[color] = _colorPopulations[color]!;
      }
    } else {
      // We need use quantization to reduce the number of colors
      _quantizedColors.addAll(_quantizePixels(validColorCount - 1, maxColors));
    }
  }

  /// Get the list of quantized colors
  List<Color> get quantizedColors => List<Color>.unmodifiable(_quantizedColors);

  /// Get the map of color populations
  Map<int, int> get quantizedColorPopulations =>
      Map<int, int>.unmodifiable(_quantizedColorPopulations);

  /// Quantize pixels to reduce the number of colors
  List<Color> _quantizePixels(int maxColorIndex, int maxColors) {
    // Create a simple list-based approach instead of priority queue
    final List<Vbox> boxes = <Vbox>[];
    boxes.add(Vbox(0, maxColorIndex, _colors, _colorPopulations));

    // Split boxes until we have enough or can't split anymore
    while (boxes.length < maxColors) {
      // Find the box with the largest volume
      Vbox? largestBox;
      int largestVolume = -1;

      for (final Vbox box in boxes) {
        if (box.canSplit && box.volume > largestVolume) {
          largestVolume = box.volume;
          largestBox = box;
        }
      }

      if (largestBox == null) {
        break; // Can't split any more boxes
      }

      // Split the largest box
      final Vbox newBox = largestBox.splitBox();
      boxes.add(newBox);
    }

    // Generate average colors from the boxes
    return _generateAverageColors(boxes);
  }

  /// Generate average colors from the boxes
  List<Color> _generateAverageColors(Iterable<Vbox> vboxes) {
    final List<Color> colors = <Color>[];
    for (final Vbox vbox in vboxes) {
      final Color color = vbox.averageColor;
      if (!_shouldIgnoreColorObject(color)) {
        // As we're averaging a color box, we can still get colors which we do not want, so
        // we check again here
        colors.add(color);
      }
    }
    return colors;
  }

  /// Check if a color int should be ignored
  bool _shouldIgnoreColorInt(int color) {
    final List<double> hsl = <double>[0.0, 0.0, 0.0];
    ColorUtils.rgbToHsl(
      ColorUtils.red(color),
      ColorUtils.green(color),
      ColorUtils.blue(color),
      hsl,
    );
    return _shouldIgnoreColorHsl(hsl);
  }

  /// Check if a Color object should be ignored
  static bool _shouldIgnoreColorObject(Color color) {
    final List<double> hsl = <double>[0.0, 0.0, 0.0];
    ColorUtils.rgbToHsl(
      (color.red * 255).round(),
      (color.green * 255).round(),
      (color.blue * 255).round(),
      hsl,
    );
    return _shouldIgnoreColorHsl(hsl);
  }

  /// Check if HSL values should be ignored
  static bool _shouldIgnoreColorHsl(List<double> hslColor) {
    return _isBlack(hslColor) ||
        _isWhite(hslColor) ||
        _isNearRedILine(hslColor);
  }

  /// Check if color is black
  static bool _isBlack(List<double> hslColor) {
    return hslColor[2] <= _blackMaxLightness;
  }

  /// Check if color is white
  static bool _isWhite(List<double> hslColor) {
    return hslColor[2] >= _whiteMinLightness;
  }

  /// Check if color is near the red I-line
  static bool _isNearRedILine(List<double> hslColor) {
    return hslColor[0] >= 10.0 && hslColor[0] <= 37.0 && hslColor[1] <= 0.82;
  }
}
