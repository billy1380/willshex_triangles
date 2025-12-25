import "package:image/image.dart" as img;
import "package:willshex_draw/willshex_draw.dart";

class ImageRenderer extends Renderer {
  img.Image image;

  ImageRenderer(this.image);

  @override
  void renderGradientRect(Rect rect, Color c1, Color c2, Color c3, Color c4) {
    final int xStart = rect.x.toInt();
    final int yStart = rect.y.toInt();
    final int w = rect.width.toInt();
    final int h = rect.height.toInt();

    for (int y = 0; y < h; y++) {
      final double fy = h > 1 ? y / (h - 1) : 0.0;
      for (int x = 0; x < w; x++) {
        final double fx = w > 1 ? x / (w - 1) : 0.0;

        // Bilinear interpolation
        // c1 (TL), c2 (TR), c3 (BR), c4 (BL) assumption
        // Actually typical order is TL, TR, BR, BL or similar.
        // Assuming c1=TL, c2=TR, c3=BR, c4=BL order based on typical quad rendering.

        // Top edge interpolation (c1 to c2)
        final double rT = c1.red + (c2.red - c1.red) * fx;
        final double gT = c1.green + (c2.green - c1.green) * fx;
        final double bT = c1.blue + (c2.blue - c1.blue) * fx;
        final double aT = c1.alpha + (c2.alpha - c1.alpha) * fx;

        // Bottom edge interpolation (c4 to c3)
        final double rB = c4.red + (c3.red - c4.red) * fx;
        final double gB = c4.green + (c3.green - c4.green) * fx;
        final double bB = c4.blue + (c3.blue - c4.blue) * fx;
        final double aB = c4.alpha + (c3.alpha - c4.alpha) * fx;

        // Vertical interpolation
        final double r = rT + (rB - rT) * fy;
        final double g = gT + (gB - gT) * fy;
        final double b = bT + (bB - bT) * fy;
        final double a = aT + (aB - aT) * fy;

        image.setPixelRgba(
          xStart + x,
          yStart + y,
          (r * 255).toInt(),
          (g * 255).toInt(),
          (b * 255).toInt(),
          (a * 255).toInt(),
        );
      }
    }
  }

  @override
  void renderRect(Rect rect, Color c) {
    img.fillRect(
      image,
      x1: rect.x.toInt(),
      y1: rect.y.toInt(),
      x2: (rect.x + rect.width).toInt(),
      y2: (rect.y + rect.height).toInt(),
      color: _toImgColor(c),
    );
  }

  @override
  void renderTriangle(Color color, Point p1, Point p2, Point p3) {
    var vertices = [
      img.Point(p1.x.toInt(), p1.y.toInt()),
      img.Point(p2.x.toInt(), p2.y.toInt()),
      img.Point(p3.x.toInt(), p3.y.toInt()),
    ];
    img.fillPolygon(
      image,
      vertices: vertices,
      color: _toImgColor(color),
    );
  }

  img.Color _toImgColor(Color c) {
    // generic_2d Color is typically 0-1 doubles or 0-255 ints.
    // Assuming 0-1 doubles based on ImageGenerator usage.
    // package:image uses different formats depending on version.
    // Version ^4.0.0 uses Color class.

    // Check if Color has exports toInt or similar.
    // If wilshex_draw Color is rgba double 0-1:
    return img.ColorFloat32.rgb(c.red, c.green, c.blue)..a = c.alpha;
  }
}
