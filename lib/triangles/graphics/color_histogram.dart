/// Class which provides a histogram for RGB values
class ColorHistogram {
  final List<int> _colors;
  final List<int> _colorCounts;
  final int _numberColors;

  /// Create a new ColorHistogram instance from an array of image pixels
  ColorHistogram(List<int> pixels) : 
    _colors = <int>[],
    _colorCounts = <int>[],
    _numberColors = _countDistinctColorsStatic(pixels) {
    
    // Sort the pixels to enable counting below
    final List<int> sortedPixels = List<int>.from(pixels)..sort();
    
    // Create arrays with proper size
    _colors.length = _numberColors;
    _colorCounts.length = _numberColors;
    
    // Finally count the frequency of each color
    _countFrequencies(sortedPixels);
  }

  /// Get the number of distinct colors in the image
  int get numberOfColors => _numberColors;

  /// Get an array containing all of the distinct colors in the image
  List<int> get colors => List<int>.unmodifiable(_colors);

  /// Get an array containing the frequency of distinct colors within the image
  List<int> get colorCounts => List<int>.unmodifiable(_colorCounts);

  /// Static method to count the number of distinct colors in the pixel array
  static int _countDistinctColorsStatic(List<int> pixels) {
    if (pixels.length < 2) {
      // If we have less than 2 pixels we can stop here
      return pixels.length;
    }

    // If we have at least 2 pixels, we have a minimum of 1 color...
    int colorCount = 1;
    int currentColor = pixels[0];

    // Now iterate from the second pixel to the end, counting distinct colors
    for (int i = 1; i < pixels.length; i++) {
      // If we encounter a new color, increase the population
      if (pixels[i] != currentColor) {
        currentColor = pixels[i];
        colorCount++;
      }
    }

    return colorCount;
  }

  /// Count the frequencies of each color in the pixel array
  void _countFrequencies(List<int> pixels) {
    if (pixels.isEmpty) {
      return;
    }

    int currentColorIndex = 0;
    int currentColor = pixels[0];

    _colors[currentColorIndex] = currentColor;
    _colorCounts[currentColorIndex] = 1;

    if (pixels.length == 1) {
      // If we only have one pixel, we can stop here
      return;
    }

    // Now iterate from the second pixel to the end, population distinct colors
    for (int i = 1; i < pixels.length; i++) {
      if (pixels[i] == currentColor) {
        // We've hit the same color as before, increase population
        _colorCounts[currentColorIndex]++;
      } else {
        // We've hit a new color, increase index
        currentColor = pixels[i];

        currentColorIndex++;
        _colors[currentColorIndex] = currentColor;
        _colorCounts[currentColorIndex] = 1;
      }
    }
  }
} 