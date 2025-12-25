import 'dart:io';
import 'package:willshex_draw/willshex_draw.dart';
import 'graphics.dart';

/// Example usage of the graphics module for color analysis and palette extraction
void main() {
  // Example 1: Basic color utilities
  stdout.writeln('=== Color Utilities Example ===');
  
  final int color = ColorUtils.argb(255, 100, 150, 200);
  stdout.writeln('Color: ${ColorUtils.red(color)}, ${ColorUtils.green(color)}, ${ColorUtils.blue(color)}');
  stdout.writeln('Luma: ${ColorUtils.calculateXyzLuma(color)}');
  stdout.writeln('Hue: ${ColorUtils.hue(color)}');
  stdout.writeln('Saturation: ${ColorUtils.saturation(color)}');
  stdout.writeln('Brightness: ${ColorUtils.brightness(color)}');

  // Example 2: Color histogram
  stdout.writeln('\n=== Color Histogram Example ===');
  
  final List<int> pixels = [
    ColorUtils.rgb(255, 0, 0),    // Red
    ColorUtils.rgb(0, 255, 0),    // Green
    ColorUtils.rgb(0, 0, 255),    // Blue
    ColorUtils.rgb(255, 0, 0),    // Red again
    ColorUtils.rgb(255, 255, 0),  // Yellow
  ];
  
  final ColorHistogram histogram = ColorHistogram(pixels);
  stdout.writeln('Number of distinct colors: ${histogram.numberOfColors}');
  stdout.writeln('Colors: ${histogram.colors}');
  stdout.writeln('Color counts: ${histogram.colorCounts}');

  // Example 3: Color quantization
  stdout.writeln('\n=== Color Quantization Example ===');
  
  final ColorCutQuantizer quantizer = ColorCutQuantizer.fromPixels(pixels, 3);
  stdout.writeln('Quantized colors: ${quantizer.quantizedColors.length}');
  for (int i = 0; i < quantizer.quantizedColors.length; i++) {
    final Color color = quantizer.quantizedColors[i];
    stdout.writeln('  Color $i: R=${(color.red * 255).round()}, G=${(color.green * 255).round()}, B=${(color.blue * 255).round()}');
  }

  // Example 4: Palette extraction
  stdout.writeln('\n=== Palette Extraction Example ===');
  
  final CanvasSamplePalette palette = CanvasSamplePalette.generate(pixels);
  stdout.writeln('Total colors in palette: ${palette.count}');
  stdout.writeln('Vibrant color: ${palette.vibrantColor != null ? "Found" : "Not found"}');
  stdout.writeln('Muted color: ${palette.mutedColor != null ? "Found" : "Not found"}');
  stdout.writeln('Dark vibrant color: ${palette.darkVibrantColor != null ? "Found" : "Not found"}');
  stdout.writeln('Light vibrant color: ${palette.lightVibrantColor != null ? "Found" : "Not found"}');
  stdout.writeln('Dark muted color: ${palette.darkMutedColor != null ? "Found" : "Not found"}');
  stdout.writeln('Light muted color: ${palette.lightMutedColor != null ? "Found" : "Not found"}');

  // Example 5: HSL conversion
  stdout.writeln('\n=== HSL Conversion Example ===');
  
  final List<double> hsl = <double>[0.0, 0.0, 0.0];
  ColorUtils.rgbToHsl(100, 150, 200, hsl);
  stdout.writeln('RGB(100, 150, 200) -> HSL(${hsl[0].toStringAsFixed(1)}, ${hsl[1].toStringAsFixed(3)}, ${hsl[2].toStringAsFixed(3)})');
  
  final int convertedColor = ColorUtils.hslToRgb(hsl);
  stdout.writeln('HSL -> RGB: ${ColorUtils.red(convertedColor)}, ${ColorUtils.green(convertedColor)}, ${ColorUtils.blue(convertedColor)}');

  // Example 6: Contrast calculation
  stdout.writeln('\n=== Contrast Calculation Example ===');
  
  final int color1 = ColorUtils.rgb(255, 255, 255); // White
  final int color2 = ColorUtils.rgb(0, 0, 0);       // Black
  final double contrast = ColorUtils.calculateContrast(color1, color2);
  stdout.writeln('Contrast between white and black: ${contrast.toStringAsFixed(3)}');
}

/// Example of how to use the graphics module with image data
class ImageColorAnalyzer {
  /// Analyze an image and extract a color palette
  static CanvasSamplePalette analyzeImage(List<int> imagePixels, {int maxColors = 16}) {
    return CanvasSamplePalette.generateWithColors(imagePixels, maxColors);
  }

  /// Get the most prominent colors from an image
  static List<Color> getProminentColors(List<int> imagePixels, {int count = 5}) {
    final CanvasSamplePalette palette = CanvasSamplePalette.generate(imagePixels);
    final List<Color> prominentColors = <Color>[];
    
    // Add vibrant colors first
    if (palette.vibrantColor != null) prominentColors.add(palette.vibrantColor!);
    if (palette.lightVibrantColor != null) prominentColors.add(palette.lightVibrantColor!);
    if (palette.darkVibrantColor != null) prominentColors.add(palette.darkVibrantColor!);
    
    // Add muted colors
    if (palette.mutedColor != null) prominentColors.add(palette.mutedColor!);
    if (palette.lightMutedColor != null) prominentColors.add(palette.lightMutedColor!);
    if (palette.darkMutedColor != null) prominentColors.add(palette.darkMutedColor!);
    
    // Add remaining colors from the palette
    for (final Color color in palette.colors) {
      if (!prominentColors.contains(color) && prominentColors.length < count) {
        prominentColors.add(color);
      }
    }
    
    return prominentColors.take(count).toList();
  }

  /// Check if two colors have sufficient contrast for accessibility
  static bool hasSufficientContrast(Color color1, Color color2, {double threshold = 0.5}) {
    final int intColor1 = ColorUtils.argb(
      (color1.alpha * 255).round(),
      (color1.red * 255).round(),
      (color1.green * 255).round(),
      (color1.blue * 255).round(),
    );
    final int intColor2 = ColorUtils.argb(
      (color2.alpha * 255).round(),
      (color2.red * 255).round(),
      (color2.green * 255).round(),
      (color2.blue * 255).round(),
    );
    
    return ColorUtils.calculateContrast(intColor1, intColor2) >= threshold;
  }
} 