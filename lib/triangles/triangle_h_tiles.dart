import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";
import "package:willshex_triangles/triangles/image_renderer.dart";

import "triangle_tiles.dart";

/// H-shaped triangle tiles pattern generator
class TriangleHTiles extends TriangleTiles {
  static const double _cos60 = 0.8660254038;

  /// Constructor with default ratio
  TriangleHTiles(Renderer renderer, Palette palette, Rect bounds,
      [bool useGradient = false])
      : super.withRatio(renderer, palette, bounds, 0.08333, useGradient);

  /// Constructor with custom ratio
  TriangleHTiles.withRatio(
      Renderer renderer, Palette palette, Rect bounds, double ratio,
      [bool useGradient = false])
      : super.withRatio(renderer, palette, bounds, ratio, useGradient);

  @override
  Point nextPoint(Point p) {
    return Point.xyPoint(p.x + lineLength, p.y);
  }

  @override
  void draw(Point origin) {
    final double tWidth = lineLength / 2.0;
    final double tHeight = lineLength * _cos60;
    final int width = (bounds.width / tWidth).floor() + 2;
    final int height = (bounds.height / tHeight).floor() + 1;

    int i = 0;
    do {
      final Point start = Point.xyPoint(origin.x - tHeight, origin.y - tHeight);
      int j = 0;

      Point p1 = start;
      Point p2 = Point.xyPoint(start.x + tWidth, start.y + tHeight);
      Point p3;

      do {
        p3 = nextPoint(p1);
        if (palette is ImagePixelPalette) {
          Point middle = Point.xyPoint(
            (p1.x + p2.x + p3.x) / 3.0,
            (p1.y + p2.y + p3.y) / 3.0,
          );
          // final image = (palette as ImagePixelPalette).source;
          int ix = (middle.x - bounds.x).floor();
          int iy = (middle.y - bounds.y).floor();
          int index = ix + (bounds.width.toInt() * iy);
          if (useGradient && renderer is ImageRenderer) {
            (renderer as ImageRenderer)
                .renderTriangle(palette[index], p1, p2, p3, true);
          } else {
            renderer.renderTriangle(palette[index], p1, p2, p3);
          }
        } else {
          if (useGradient && renderer is ImageRenderer) {
            (renderer as ImageRenderer)
                .renderTriangle(palette.randomColor, p1, p2, p3, true);
          } else {
            renderer.renderTriangle(palette.randomColor, p1, p2, p3);
          }
        }

        p1 = p2;
        p2 = p3;
        j++;
      } while (j <= ((i % 2 == 0) ? width : width + 1));

      origin = Point.xyPoint(
        origin.x + (i % 2 == 0 ? -tWidth : tWidth),
        origin.y + tHeight,
      );
      i++;
    } while (i <= height);
  }
}
