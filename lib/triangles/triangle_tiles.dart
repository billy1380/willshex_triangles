import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/image_renderer.dart";

/// Base class for triangle tile generation
class TriangleTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;
  final bool _useGradient;

  static const double _cos60 = 0.8660254038;

  /// Constructor with default ratio
  TriangleTiles(this._renderer, this._palette, this._bounds,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  /// Constructor with custom ratio
  TriangleTiles.withRatio(
      this._renderer, this._palette, this._bounds, double ratio,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  /// Get the next point in the triangle pattern
  Point nextPoint(Point p) {
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

      do {
        p3 = nextPoint(p1);
        if (_useGradient && _renderer is ImageRenderer) {
          (_renderer as ImageRenderer)
              .renderTriangle(_palette.randomColor, p1, p2, p3, true);
        } else {
          _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
        }

        p1 = p2;
        p2 = p3;
        j++;
      } while (j <= ((i % 2 == 0) ? height : height + 1));

      origin = Point.xyPoint(
        origin.x + tWidth,
        origin.y + (i % 2 == 0 ? -tHeight : tHeight),
      );
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

  // Protected getters for subclasses
  double get lineLength => _lineLength;
  Rect get bounds => _bounds;
  Renderer get renderer => _renderer;
  Palette get palette => _palette;
  bool get useGradient => _useGradient;
}
