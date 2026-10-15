# Graphics Module

This module provides color analysis and palette extraction utilities, ported from Android's Palette library and adapted for Dart/Flutter.

## Overview

The graphics module contains tools for:
- Color space conversions (RGB, HSL, XYZ)
- Color histogram analysis
- Color quantization using median-cut algorithm
- Palette extraction with vibrant, muted, light, and dark color variants

## Components

### ColorUtils
Utility class for color operations and conversions:
- RGB to HSL conversion
- HSL to RGB conversion
- Color component extraction (red, green, blue, alpha)
- Luma calculation
- Contrast calculation
- Hue, saturation, and brightness extraction

### ColorHistogram
Analyzes pixel data to create a histogram of distinct colors:
- Counts distinct colors in an image
- Tracks color frequencies
- Provides efficient color analysis

### ColorCutQuantizer
Implements median-cut color quantization algorithm:
- Reduces color palette while preserving distinct colors
- Optimized for picking out distinct colors rather than representative colors
- Uses volume-based splitting instead of population-based splitting

### CanvasSamplePalette
Extracts prominent colors from image data:
- Generates vibrant, muted, light, and dark color variants
- Provides fallback colors for missing variants
- Integrates with the willshex_draw Palette class

## Usage Examples

### Basic Color Analysis
```dart
import 'package:willshex_triangles/triangles.dart';

// Analyze pixel data
final List<int> pixels = [/* your pixel data */];
final CanvasSamplePalette palette = CanvasSamplePalette.generate(pixels);

// Get prominent colors
final Color? vibrantColor = palette.vibrantColor;
final Color? mutedColor = palette.mutedColor;
final Color? darkVibrantColor = palette.darkVibrantColor;
```

### Color Utilities
```dart
import 'package:willshex_triangles/triangles.dart';

// Convert RGB to HSL
final List<double> hsl = <double>[0.0, 0.0, 0.0];
ColorUtils.rgbToHsl(100, 150, 200, hsl);

// Calculate contrast
final double contrast = ColorUtils.calculateContrast(color1, color2);
```

### Custom Quantization
```dart
import 'package:willshex_triangles/triangles.dart';

// Create custom quantizer
final ColorCutQuantizer quantizer = ColorCutQuantizer.fromPixels(pixels, 8);
final List<Color> quantizedColors = quantizer.quantizedColors;
```

## Integration with Triangle Generation

The graphics module can be used to:
- Extract color palettes from background images
- Generate triangle patterns with colors that complement the image
- Create harmonious color schemes for triangle designs
- Analyze image content for adaptive triangle generation

## Dependencies

- `willshex_draw`: For Color and Palette classes
- `dart:math`: For mathematical operations

## Notes

- The module is based on Android's Palette library but adapted for Dart/Flutter
- Color quantization uses a simplified median-cut algorithm optimized for distinct colors
- All color values are normalized to 0.0-1.0 range for consistency with willshex_draw
- The module is designed to work with pixel data as integer arrays (ARGB format)

## Port Status

✅ **Completed:**
- ColorUtils class with all utility methods
- ColorHistogram for color frequency analysis
- ColorCutQuantizer with median-cut algorithm
- CanvasSamplePalette for palette extraction
- Integration with willshex_draw Palette class
- Example usage and documentation

🔄 **Adaptations from Java:**
- Simplified priority queue implementation
- Dart-style naming conventions
- Null safety support
- Integration with existing willshex_draw classes
- Flutter-compatible color handling 