import 'dart:math';
import 'package:willshex_draw/willshex_draw.dart';

/// Square-based triangle tiles pattern generator
class TriangleSquareTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;
  final Random _random = Random();

  /// Constructor with default ratio
  TriangleSquareTiles(this._renderer, this._palette, this._bounds)
      : _lineLength = (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) * 0.08333;

  /// Constructor with custom ratio
  TriangleSquareTiles.withRatio(this._renderer, this._palette, this._bounds, double ratio)
      : _lineLength = (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) * ratio;

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
        topPointLeft = _random.nextBool();
        if (topPointLeft) {
          _renderer.renderTriangle(_palette.randomColor, p1, p4, p2);
          _renderer.renderTriangle(_palette.randomColor, p2, p3, p4);
        } else {
          _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
          _renderer.renderTriangle(_palette.randomColor, p1, p4, p3);
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
    if (_palette.count < 4) return;

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