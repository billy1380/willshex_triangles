import "package:willshex_draw/willshex_draw.dart";

/// Triangle tiles overlaid on an image pattern generator
class TriangleTilesOverImage {
  final Renderer _renderer;
  final Rect _bounds;
  final Palette _palette;
  final double _lineLength;

  static const double _cos60 = 0.8660254038;

  /// Constructor with default ratio
  TriangleTilesOverImage(this._renderer, this._palette, this._bounds)
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  /// Constructor with custom ratio
  TriangleTilesOverImage.withRatio(
      this._renderer, this._palette, this._bounds, double ratio)
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  /// Get the next point in the triangle pattern
  Point _nextPoint(Point p) {
    return Point.xyPoint(p.x, p.y + _lineLength);
  }

  /// Draw triangles from the given origin point
  void draw(Point origin) {
    final double tWidth = _lineLength * _cos60;
    final double tHeight = _lineLength / 2.0;
    final int width = (_bounds.width / tWidth).floor() + 1;
    final int height = (_bounds.height / tHeight).floor() + 1;

    int i = 0;
    do {
      final Point start = Point.xyPoint(origin.x, origin.y - tHeight);
      int j = 0;

      Point p1 = start;
      Point p2 = Point.xyPoint(start.x + tWidth, start.y + tHeight);
      Point p3;

      final Point middle = Point.xyPoint(0, 0);
      int index;

      do {
        p3 = _nextPoint(p1);

        if (i % 2 == 0) {
          middle.y = (p1.y + p2.y) * 0.5;
        } else {
          middle.y = (p1.y + p3.y) * 0.5;
        }

        index = middle.x.floor() + (_bounds.width.floor() * middle.y.floor());
        _renderer.renderTriangle(_palette[index % _palette.count], p1, p2, p3);

        p1 = p2;
        p2 = p3;
        j++;
      } while (j <= height);

      origin = Point.xyPoint(
        origin.x + tWidth,
        origin.y + (i % 2 == 0 ? -tHeight : tHeight),
      );
      i++;
    } while (i <= width);
  }

  /// Draw the default layout with solid background
  void defaultLayout() {
    _renderer.renderRect(_bounds, _palette[0]);
    draw(Point.xyPoint(_bounds.x, _bounds.y));
  }
}
