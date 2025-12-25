import 'dart:math';
import 'package:willshex_draw/willshex_draw.dart';

/// Triangle tiles with random jiggle effect
/// Ported from Java TriangleRandomJiggleTiles.java
class TriangleRandomJiggleTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;

  static const double _cos60 = 0.8660254038;

  final List<Point> _jiggledPointsLeft = <Point>[];
  final List<Point> _jiggledPointsRight = <Point>[];

  final Random _random = Random();

  /// Constructor with default ratio
  TriangleRandomJiggleTiles(this._renderer, this._palette, this._bounds)
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  /// Constructor with custom ratio
  TriangleRandomJiggleTiles.withRatio(
      this._renderer, this._palette, this._bounds, double ratio)
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  /// Get the next point in the triangle pattern
  Point _nextPoint(Point p) {
    return Point.xyPoint(p.x, p.y + _lineLength);
  }

  /// Apply random jiggle to a point
  Point _jiggle(Point p) {
    return Point.xyPoint(
      p.x + ((_random.nextDouble() - 0.5) * _lineLength),
      p.y + ((_random.nextDouble() - 0.5) * _lineLength),
    );
  }

  /// Draw triangles from the given origin point
  void draw(Point origin) {
    origin = _adjustOrigin(origin);

    final double tWidth = _lineLength * _cos60;
    final double tHeight = _lineLength / 2.0;
    final int width = (_width() / tWidth).floor() + 1;
    final int height = (_height() / tHeight).floor() + 1;

    _jiggledPointsLeft.clear();
    _jiggledPointsRight.clear();

    List<Point> temp;
    bool first;

    int i = 0;
    do {
      first = (_jiggledPointsLeft.isEmpty);

      final Point start = Point.xyPoint(origin.x, origin.y - tHeight);

      int j = 0;

      Point p1 = start;
      Point p2 = Point.xyPoint(start.x + tWidth, start.y + tHeight);
      Point? p3;

      if (first) {
        _jiggledPointsLeft.add(_jiggle(p1));
      }

      _jiggledPointsRight.add(_jiggle(p2));

      do {
        p3 = _nextPoint(p1);

        if (j % 2 == 0) {
          if (first) {
            _jiggledPointsLeft.add(_jiggle(p3));
          }
        } else {
          _jiggledPointsRight.add(_jiggle(p3));
        }

        p1 = p2;
        p2 = p3;
        j++;
      } while (j <= ((i % 2 == 0) ? height : height + 1));

      for (int r = 0; r < _jiggledPointsLeft.length; r++) {
        Point? p1 = _jiggledPointsLeft[r];
        Point? p2 =
            _jiggledPointsRight.length <= r ? null : _jiggledPointsRight[r];

        if (i % 2 == 0) {
          p3 = _jiggledPointsLeft.length <= r + 1
              ? null
              : _jiggledPointsLeft[r + 1];
        } else {
          p3 = _jiggledPointsRight.length <= r + 1
              ? null
              : _jiggledPointsRight[r + 1];
        }

        if (p2 != null && p3 != null) {
          _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
        }

        if (i % 2 == 0) {
          p1 = p2!;
          p2 = p3!;
          p3 = _jiggledPointsRight.length <= r + 1
              ? null
              : _jiggledPointsRight[r + 1];
        } else {
          p2 = p3!;
          p3 = _jiggledPointsLeft.length <= r + 1
              ? null
              : _jiggledPointsLeft[r + 1];
        }

        if (p3 != null) {
          _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
        }
      }

      // Color c = NamedColorHelper.lookup("Blue");
      // for (Point point : pointsLeft) {
      //   drawCircleAtPoint(c, point);
      // }
      // c = NamedColorHelper.lookup("Yellow");
      // for (Point point : pointsRight) {
      //   drawCircleAtPoint(c, point);
      // }

      temp = List<Point>.from(_jiggledPointsLeft);
      _jiggledPointsLeft.clear();
      _jiggledPointsLeft.addAll(_jiggledPointsRight);
      _jiggledPointsRight.clear();
      _jiggledPointsRight.addAll(temp);

      origin = Point.xyPoint(
        origin.x + tWidth,
        origin.y + (i % 2 == 0 ? -tHeight : tHeight),
      );
      i++;
    } while (i <= width);
  }

  /// Adjust origin point for jiggle effect
  Point _adjustOrigin(Point origin) {
    // return origin.add(Point.xyPoint(50, 50));
    // return origin.add(Point.xyPoint(_lineLength * -10, _lineLength * -10));
    return origin + Point.xyPoint(-_lineLength, -_lineLength);
    // return origin.add(Point.xyPoint(_lineLength * 10, _lineLength * 10));
    // return origin;
  }

  /// Get effective width for jiggle calculations
  double _width() {
    // return _bounds.width - 100;
    // return _bounds.width;
    // return _bounds.width + (_lineLength * 20);
    // return _bounds.width - (_lineLength * 20);
    return _bounds.width + _lineLength;
  }

  /// Get effective height for jiggle calculations
  double _height() {
    // return _bounds.height - 100;
    // return _bounds.height;
    // return _bounds.height + (_lineLength * 20);
    // return _bounds.height - (_lineLength * 20);
    return _bounds.height + _lineLength;
  }

  /// Draw the default layout with gradient background
  void defaultLayout() {
    if (_palette.count < 4) return;

    // _renderer.renderGradientRect(_bounds, NamedColorHelper.lookup("White"), NamedColorHelper.lookup("White"), NamedColorHelper.lookup("White"), NamedColorHelper.lookup("White"));
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
