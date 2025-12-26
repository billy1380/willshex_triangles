import "package:logging/logging.dart";
import "package:willshex_draw/willshex_draw.dart";

class RandomColorPalette extends Palette {
  static final Logger _log = Logger("RandomColorPalette");

  RandomColorPalette([super.name = "Random Colors", super.externalId]);

  /// Generate random colors locally as fallback
  void generateRandomColors([int? count]) {
    final List<Color> colors = <Color>[];

    count ??= 4 + RandomHelper.random.nextInt(4);

    // Generate different types of color palettes
    final int paletteType = RandomHelper.random.nextInt(4);

    switch (paletteType) {
      case 0:
        generateWarmPalette(count, colors);
        break;
      case 1:
        generateCoolPalette(count, colors);
        break;
      case 2:
        generateComplementaryPalette(count, colors);
        break;
      case 3:
        generateAnalogousPalette(count, colors);
        break;
    }

    addColors(colors);

    _log.info(
        "Generated ${colors.length} random colors locally (palette type: $paletteType)");
  }

  /// Generate warm color palette (reds, oranges, yellows)
  void generateWarmPalette(int count, List<Color> colors) {
    name = "Random Warm Colors";
    for (int i = 0; i < count; i++) {
      final double r = 0.5 + RandomHelper.random.nextDouble() * 0.5; // 0.5-1.0
      final double g = RandomHelper.random.nextDouble() * 0.6; // 0.0-0.6
      final double b = RandomHelper.random.nextDouble() * 0.3; // 0.0-0.3
      colors.add(Color.rgbaColor(r, g, b));
    }
  }

  /// Generate cool color palette (blues, greens, purples)
  void generateCoolPalette(int count, List<Color> colors) {
    name = "Random Cool Colors";
    for (int i = 0; i < count; i++) {
      final double r = RandomHelper.random.nextDouble() * 0.4; // 0.0-0.4
      final double g = RandomHelper.random.nextDouble() * 0.7; // 0.0-0.7
      final double b = 0.4 + RandomHelper.random.nextDouble() * 0.6; // 0.4-1.0
      colors.add(Color.rgbaColor(r, g, b));
    }
  }

  /// Generate complementary color palette
  void generateComplementaryPalette(int count, List<Color> colors) {
    name = "Random Complementary Colors";
    final double baseHue = RandomHelper.random.nextDouble();

    for (int i = 0; i < count; i++) {
      final double hue = (baseHue + i * 0.1667) % 1.0; // 60-degree intervals
      final double saturation =
          0.6 + RandomHelper.random.nextDouble() * 0.4; // 0.6-1.0
      final double value =
          0.7 + RandomHelper.random.nextDouble() * 0.3; // 0.7-1.0

      final List<double> rgb = _hsvToRgb(hue, saturation, value);
      colors.add(Color.rgbaColor(rgb[0], rgb[1], rgb[2]));
    }
  }

  /// Generate analogous color palette
  void generateAnalogousPalette(int count, List<Color> colors) {
    name = "Random Analogous Colors";
    final double baseHue = RandomHelper.random.nextDouble();

    for (int i = 0; i < count; i++) {
      final double hue = (baseHue + i * 0.125) % 1.0; // 45-degree intervals
      final double saturation =
          0.5 + RandomHelper.random.nextDouble() * 0.5; // 0.5-1.0
      final double value =
          0.6 + RandomHelper.random.nextDouble() * 0.4; // 0.6-1.0

      final List<double> rgb = _hsvToRgb(hue, saturation, value);
      colors.add(Color.rgbaColor(rgb[0], rgb[1], rgb[2]));
    }
  }

  /// Convert HSV to RGB
  List<double> _hsvToRgb(double h, double s, double v) {
    final int i = (h * 6).floor();
    final double f = h * 6 - i;
    final double p = v * (1 - s);
    final double q = v * (1 - f * s);
    final double t = v * (1 - (1 - f) * s);

    switch (i % 6) {
      case 0:
        return [v, t, p];
      case 1:
        return [q, v, p];
      case 2:
        return [p, v, t];
      case 3:
        return [p, q, v];
      case 4:
        return [t, p, v];
      case 5:
        return [v, p, q];
      default:
        return [v, t, p];
    }
  }
}
