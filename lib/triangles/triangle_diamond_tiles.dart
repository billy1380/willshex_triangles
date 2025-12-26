import "dart:math";

import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/image_renderer.dart";

/// Diamond-shaped triangle tiles pattern generator (squares rotated 45°)
class TriangleDiamondTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;
  final bool _useGradient;
  final Random _random = Random();

  /// Constructor with default ratio
  TriangleDiamondTiles(this._renderer, this._palette, this._bounds,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  /// Constructor with custom ratio
  TriangleDiamondTiles.withRatio(
      this._renderer, this._palette, this._bounds, double ratio,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  /// Draw diamonds from the given origin point
  void draw(Point origin) {
    // For diamonds, we need to calculate diamond dimensions
    // A diamond is a square rotated 45°, so diagonal = lineLength * sqrt(2)
    final double diagonal = _lineLength * sqrt2;
    final double halfDiagonal = diagonal / 2;

    final int width = (_bounds.width / diagonal).floor() + 2;
    final int height = (_bounds.height / diagonal).floor() + 2;

    int i = 0;
    do {
      int j = 0;

      // Start position for this column
      Point center = Point.xyPoint(
        origin.x + halfDiagonal + (i * diagonal),
        origin.y + halfDiagonal + ((i % 2) * halfDiagonal),
      );

      do {
        // Diamond points: top, right, bottom, left
        final Point top = Point.xyPoint(center.x, center.y - halfDiagonal);
        final Point right = Point.xyPoint(center.x + halfDiagonal, center.y);
        final Point bottom = Point.xyPoint(center.x, center.y + halfDiagonal);
        final Point left = Point.xyPoint(center.x - halfDiagonal, center.y);

        // Randomly choose diagonal split direction
        final bool splitTopLeftToBottomRight = _random.nextBool();

        if (splitTopLeftToBottomRight) {
          // Split from top-left to bottom-right
          if (_useGradient && _renderer is ImageRenderer) {
            (_renderer as ImageRenderer)
                .renderTriangle(_palette.randomColor, top, right, bottom, true);
            (_renderer as ImageRenderer)
                .renderTriangle(_palette.randomColor, top, left, bottom, true);
          } else {
            _renderer.renderTriangle(_palette.randomColor, top, right, bottom);
            _renderer.renderTriangle(_palette.randomColor, top, left, bottom);
          }
        } else {
          // Split from top-right to bottom-left
          if (_useGradient && _renderer is ImageRenderer) {
            (_renderer as ImageRenderer)
                .renderTriangle(_palette.randomColor, top, right, left, true);
            (_renderer as ImageRenderer).renderTriangle(
                _palette.randomColor, right, bottom, left, true);
          } else {
            _renderer.renderTriangle(_palette.randomColor, top, right, left);
            _renderer.renderTriangle(_palette.randomColor, right, bottom, left);
          }
        }

        center = Point.xyPoint(center.x, center.y + diagonal);
        j++;
      } while (j <= height);

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
