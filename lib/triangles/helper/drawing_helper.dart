import 'dart:math';
import 'package:willshex_draw/willshex_draw.dart';

/// Helper class for drawing operations
class DrawingHelper {
  /// Draw a circle at a specific point
  static void drawCircleAtPoint(Renderer renderer, Color color, Point point) {
    const double radius = 5;
    const int segments = 16;
    const double phi = 2 * pi / segments;

    double x, y;
    Point p1 = point;
    Point? p2;
    Point? p3;
    double angle;

    for (int i = 0; i < segments; i++) {
      angle = (i + 0.5) * phi;
      x = radius * cos(angle);
      y = radius * sin(angle);

      p2 ??= Point.xyPoint(p1.x + x, p1.y + y);

      p3 = Point.xyPoint(p1.x + x, p1.y - y);
      renderer.renderTriangle(color, p1, p2, p3);
      p2 = p3;
    }
  }
} 