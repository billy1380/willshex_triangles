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

    // Calculate how many diamonds we need to cover the canvas with extra margin
    final int width = (_bounds.width / diagonal).ceil() + 2;
    final int height = (_bounds.height / diagonal).ceil() + 2;

    // Simple nested loop for proper tiling
    for (int j = -1; j < height; j++) {
      for (int i = -1; i < width; i++) {
        // Offset every other row by half a diagonal for tessellation
        final double xOffset = (j % 2) * halfDiagonal;

        // Center position for this diamond
        final Point center = Point.xyPoint(
          origin.x + (i * diagonal) + halfDiagonal + xOffset,
          origin.y + (j * diagonal) + halfDiagonal,
        );

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
      }
    }
  }

  /// Draw the default layout without background
  void defaultLayout() {
    if (_palette.count < 1) return;

    // No gradient background - just draw the diamonds
    draw(Point.xyPoint(_bounds.x, _bounds.y));
  }
}
