import 'dart:math';
import 'package:willshex_draw/willshex_draw.dart';

/// Triangle ribbons pattern generator
class TriangleRibbons {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final Random _random = Random();
  final List<Point> _triangles = <Point>[];
  final int _count;
  final double _lineLength;

  static const double _pi2 = 2.0 * pi;

  /// Constructor with default ratio
  TriangleRibbons(this._renderer, this._palette, this._bounds, this._count)
      : _lineLength = (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) * 0.08333;

  /// Constructor with custom ratio
  TriangleRibbons.withRatio(this._renderer, this._palette, this._bounds, this._count, double ratio)
      : _lineLength = (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) * ratio;

  /// Check if a point is inside the bounds
  bool _inside(Point p) {
    return (p.x >= _bounds.x) &&
        (p.x <= _bounds.x + _bounds.width) &&
        (p.y >= _bounds.y) &&
        (p.y <= _bounds.y + _bounds.height);
  }

  /// Check if a point is inside a triangle
  bool _pointInTriangle(Point p, Point a, Point b, Point c) {
    final double ab = (p.y - a.y) * (b.x - a.x) - (p.x - a.x) * (b.y - a.y);
    final double ca = (p.y - c.y) * (a.x - c.x) - (p.x - c.x) * (a.y - c.y);
    final double bc = (p.y - b.y) * (c.x - b.x) - (p.x - b.x) * (c.y - b.y);

    return (ab * bc > 0) && (bc * ca > 0);
  }

  /// Check if a point is inside any of the existing triangles
  bool _pointInTriangles(Point p) {
    final int count = _triangles.length;
    for (int i = 0; i < count - 2; i++) {
      if (_pointInTriangle(p, _triangles[i], _triangles[i + 1], _triangles[i + 2])) {
        return true;
      }
    }
    return false;
  }

  /// Get the next point in the ribbon pattern
  Point _nextPoint(Point p) {
    Point pN;
    do {
      final double angle = _random.nextDouble() * _pi2;
      pN = Point.xyPoint(
        p.x + (_lineLength * cos(angle)),
        p.y + (_lineLength * sin(angle)),
      );
    } while (!_inside(pN) || _pointInTriangles(pN));

    return pN;
  }

  /// Draw triangles from the given origin point
  void draw(Point origin) {
    _triangles.clear();

    _triangles.add(_nextPoint(origin));
    _triangles.add(_nextPoint(origin));

    for (int i = 0; i < _count; i++) {
      final Point p1 = _triangles[i];
      final Point p2 = _triangles[i + 1];
      final Point p3 = _nextPoint(p2);
      _triangles.add(p3);

      _renderer.renderTriangle(_palette.randomColor, p1, p2, p3);
    }
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

    // Draw ribbons from multiple starting points
    draw(Point.xyPoint(_bounds.x + _bounds.width / 2.0, _bounds.y + _bounds.height / 2.0));
    draw(Point.xyPoint(_bounds.x, _bounds.y));
    draw(Point.xyPoint(_bounds.x + _bounds.width, _bounds.y));
    draw(Point.xyPoint(_bounds.x + _bounds.width, _bounds.y + _bounds.height));
    draw(Point.xyPoint(_bounds.x, _bounds.y + _bounds.height));
  }
} 