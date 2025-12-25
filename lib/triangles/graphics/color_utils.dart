import "dart:math" as math;

/// Utility class for color operations and conversions
class ColorUtils {
  ColorUtils._(); // Private constructor to prevent instantiation

  /// Calculate luma value according to XYZ color space in the range 0.0 - 1.0
  static double calculateXyzLuma(int color) {
    return (0.2126 * red(color) +
            0.7152 * green(color) +
            0.0722 * blue(color)) /
        255.0;
  }

  /// Calculate contrast between two colors
  static double calculateContrast(int color1, int color2) {
    return (calculateXyzLuma(color1) - calculateXyzLuma(color2)).abs();
  }

  /// Convert RGB values to HSL
  static void rgbToHsl(int r, int g, int b, List<double> hsl) {
    final double rf = r / 255.0;
    final double gf = g / 255.0;
    final double bf = b / 255.0;

    final double max = math.max(rf, math.max(gf, bf));
    final double min = math.min(rf, math.min(gf, bf));
    final double deltaMaxMin = max - min;

    double h, s;
    double l = (max + min) / 2.0;

    if (max == min) {
      // Monochromatic
      h = s = 0.0;
    } else {
      if (max == rf) {
        h = ((gf - bf) / deltaMaxMin) % 6.0;
      } else if (max == gf) {
        h = ((bf - rf) / deltaMaxMin) + 2.0;
      } else {
        h = ((rf - gf) / deltaMaxMin) + 4.0;
      }

      s = deltaMaxMin / (1.0 - (2.0 * l - 1.0).abs());
    }

    hsl[0] = (h * 60.0) % 360.0;
    hsl[1] = s;
    hsl[2] = l;
  }

  /// Convert HSL values to RGB
  static int hslToRgb(List<double> hsl) {
    final double h = hsl[0];
    final double s = hsl[1];
    final double l = hsl[2];

    final double c = (1.0 - (2 * l - 1.0).abs()) * s;
    final double m = l - 0.5 * c;
    final double x = c * (1.0 - ((h / 60.0 % 2.0) - 1.0).abs());

    final int hueSegment = (h / 60.0).floor();

    int r = 0, g = 0, b = 0;

    switch (hueSegment) {
      case 0:
        r = (255 * (c + m)).round();
        g = (255 * (x + m)).round();
        b = (255 * m).round();
        break;
      case 1:
        r = (255 * (x + m)).round();
        g = (255 * (c + m)).round();
        b = (255 * m).round();
        break;
      case 2:
        r = (255 * m).round();
        g = (255 * (c + m)).round();
        b = (255 * (x + m)).round();
        break;
      case 3:
        r = (255 * m).round();
        g = (255 * (x + m)).round();
        b = (255 * (c + m)).round();
        break;
      case 4:
        r = (255 * (x + m)).round();
        g = (255 * m).round();
        b = (255 * (c + m)).round();
        break;
      case 5:
      case 6:
        r = (255 * (c + m)).round();
        g = (255 * m).round();
        b = (255 * (x + m)).round();
        break;
    }

    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return rgb(r, g, b);
  }

  /// Return the alpha component of a color int
  static int alpha(int color) {
    return color >>> 24;
  }

  /// Return the red component of a color int
  static int red(int color) {
    return (color >> 16) & 0xFF;
  }

  /// Return the green component of a color int
  static int green(int color) {
    return (color >> 8) & 0xFF;
  }

  /// Return the blue component of a color int
  static int blue(int color) {
    return color & 0xFF;
  }

  /// Return a color-int from red, green, blue components
  static int rgb(int red, int green, int blue) {
    return (0xFF << 24) | (red << 16) | (green << 8) | blue;
  }

  /// Return a color-int from alpha, red, green, blue components
  static int argb(int alpha, int red, int green, int blue) {
    return (alpha << 24) | (red << 16) | (green << 8) | blue;
  }

  /// Returns the hue component of a color int
  static double hue(int color) {
    int r = (color >> 16) & 0xFF;
    int g = (color >> 8) & 0xFF;
    int b = color & 0xFF;

    int v = math.max(b, math.max(r, g));
    int temp = math.min(b, math.min(r, g));

    double h;

    if (v == temp) {
      h = 0;
    } else {
      final double vtemp = (v - temp).toDouble();
      final double cr = (v - r) / vtemp;
      final double cg = (v - g) / vtemp;
      final double cb = (v - b) / vtemp;

      if (r == v) {
        h = cb - cg;
      } else if (g == v) {
        h = (2.0 + cr) - cb;
      } else {
        h = (4.0 + cg) - cr;
      }

      h = 60.0 * h;
      if (h < 0) {
        h += 360.0;
      }
    }

    return h / 360.0;
  }

  /// Returns the saturation component of a color int
  static double saturation(int color) {
    int r = (color >> 16) & 0xFF;
    int g = (color >> 8) & 0xFF;
    int b = color & 0xFF;

    int v = math.max(b, math.max(r, g));
    int temp = math.min(b, math.min(r, g));

    if (v == temp) {
      return 0.0;
    }

    final double l = (v + temp) / 2.0;
    final double s =
        (v - temp) / (l <= 127.5 ? (v + temp) : (510.0 - v - temp));
    return s;
  }

  /// Returns the brightness component of a color int
  static double brightness(int color) {
    int r = (color >> 16) & 0xFF;
    int g = (color >> 8) & 0xFF;
    int b = color & 0xFF;

    int v = math.max(b, math.max(r, g));
    return v / 255.0;
  }
}
