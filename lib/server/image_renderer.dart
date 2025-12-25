import 'package:image/image.dart' as img;
import 'package:willshex_draw/willshex_draw.dart';

class ImageRenderer extends Renderer {
  img.Image image;

  ImageRenderer(this.image);

  @override
  void renderGradientRect(Rect rect, Color c1, Color c2, Color c3, Color c4) {
    // Basic implementation: Average color fill for now as package:image
    // doesn't have a direct gradient fill for arbitrary quads easily accessible.
    // A better implementation would be to interpolate pixels, but for now
    // let's fill with the average color or c1.
    // Simple fill for now to get it working.
    // TODO: Implement proper gradient filling
    renderRect(rect, c1);
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
