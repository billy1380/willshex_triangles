import "package:image/image.dart" as img;

extension ImagePixelExtension on img.Image {
  /// Extract all pixels as ARGB integers for palette generation
  List<int> toArgbPixels() {
    final pixels = <int>[];
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = getPixel(x, y);
        final a = pixel.a.toInt();
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();
        pixels.add((a << 24) | (r << 16) | (g << 8) | b);
      }
    }
    return pixels;
  }
}
