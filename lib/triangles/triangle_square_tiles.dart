import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";
import "package:willshex_triangles/triangles/image_renderer.dart";

/// Square-based triangle tiles pattern generator
class TriangleSquareTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;
  final bool _useGradient;

  /// Constructor with default ratio
  TriangleSquareTiles(this._renderer, this._palette, this._bounds,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  /// Constructor with custom ratio
  TriangleSquareTiles.withRatio(
      this._renderer, this._palette, this._bounds, double ratio,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  /// Draw triangles from the given origin point
  void draw(Point origin) {
    final double tWidth = _lineLength;
    final double tHeight = _lineLength;
    final int width = (_bounds.width / tWidth).floor() + 1;
    final int height = (_bounds.height / tHeight).floor() + 1;

    int i = 0;
    do {
      int j = 0;

      bool topPointLeft;

      Point p1 = origin;
      Point p2 = Point.xyPoint(p1.x + tWidth, p1.y);
      Point p3 = Point.xyPoint(p2.x, p2.y + tHeight);
      Point p4 = Point.xyPoint(p1.x, p3.y);

      do {
        topPointLeft = RandomHelper.random.nextBool();
        if (topPointLeft) {
          if (_palette is ImagePixelPalette) {
            Point middle1 = Point.xyPoint(
                (p1.x + p4.x + p2.x) / 3.0, (p1.y + p4.y + p2.y) / 3.0);
            Point middle2 = Point.xyPoint(
                (p2.x + p3.x + p4.x) / 3.0, (p2.y + p3.y + p4.y) / 3.0);

            // final image = (_palette as ImagePixelPalette).source;
            int ix1 = (middle1.x - _bounds.x).floor();
            int iy1 = (middle1.y - _bounds.y).floor();
            int ix2 = (middle2.x - _bounds.x).floor();
            int iy2 = (middle2.y - _bounds.y).floor();

            int index1 = ix1 + (_bounds.width.toInt() * iy1);
            int index2 = ix2 + (_bounds.width.toInt() * iy2);

            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index1], p1, p4, p2, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index2], p2, p3, p4, true);
            } else {
              _renderer.renderTriangle(_palette[index1], p1, p4, p2);
              _renderer.renderTriangle(_palette[index2], p2, p3, p4);
            }
          } else {
            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette.randomColor, p1, p4, p2, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette.randomColor, p2, p3, p4, true);
            } else {
              _renderer.renderTriangle(_palette.randomColor, p1, p4, p2);
              _renderer.renderTriangle(_palette.randomColor, p2, p3, p4);
            }
          }
        } else {
          if (_palette is ImagePixelPalette) {
            Point middle1 = Point.xyPoint(
                (p1.x + p2.x + p3.x) / 3.0, (p1.y + p2.y + p3.y) / 3.0);
            Point middle2 = Point.xyPoint(
                (p1.x + p4.x + p3.x) / 3.0, (p1.y + p4.y + p3.y) / 3.0);

            // final image = (_palette as ImagePixelPalette).source;
            int ix1 = (middle1.x - _bounds.x).floor();
            int iy1 = (middle1.y - _bounds.y).floor();
            int ix2 = (middle2.x - _bounds.x).floor();
            int iy2 = (middle2.y - _bounds.y).floor();

            int index1 = ix1 + (_bounds.width.toInt() * iy1);
            int index2 = ix2 + (_bounds.width.toInt() * iy2);

            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index1], p1, p2, p3, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index2], p1, p4, p3, true);
            } else {
              _renderer.renderTriangle(_palette[index1], p1, p2, p3);
              _renderer.renderTriangle(_palette[index2], p1, p4, p3);
            }
          } else {
            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette.randomColor, p1, p2, p3, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette.randomColor, p1, p4, p3, true);
            } else {
              _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
              _renderer.renderTriangle(_palette.randomColor, p1, p4, p3);
            }
          }
        }

        p1 = p4;
        p2 = p3;
        p3 = Point.xyPoint(p2.x, p2.y + tHeight);
        p4 = Point.xyPoint(p1.x, p3.y);
        j++;
      } while (j <= height);

      origin = Point.xyPoint(origin.x + tWidth, origin.y);
      i++;
    } while (i <= width);
  }

  /// Draw the default layout with gradient background
  void defaultLayout() {
    if (_palette.count < 1) return;

    _renderer.renderGradientRect(
      _bounds,
      _palette[0],
      _palette[1],
      _palette[2],
      _palette[3],
    );
    draw(Point.xyPoint(_bounds.x, _bounds.y));
  }
}
