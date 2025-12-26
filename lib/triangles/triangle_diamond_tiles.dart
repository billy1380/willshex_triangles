import "dart:math";

import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";
import "package:willshex_triangles/triangles/image_renderer.dart";

class TriangleDiamondTiles {
  final Renderer _renderer;
  final Palette _palette;
  final Rect _bounds;
  final double _lineLength;
  final bool _useGradient;
  final Random _random = Random();

  TriangleDiamondTiles(this._renderer, this._palette, this._bounds,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                0.08333;

  TriangleDiamondTiles.withRatio(
      this._renderer, this._palette, this._bounds, double ratio,
      [this._useGradient = false])
      : _lineLength =
            (_bounds.width > _bounds.height ? _bounds.height : _bounds.width) *
                ratio;

  void draw(Point origin) {
    final double diagonal = _lineLength * sqrt2;
    final double halfDiagonal = diagonal / 2;

    final int cols = (_bounds.width / diagonal).ceil() + 3;
    final int rows = (_bounds.height / halfDiagonal).ceil() + 3;

    for (int row = -2; row < rows; row++) {
      final double xOffset = (row % 2 == 0) ? 0 : halfDiagonal;

      for (int col = -2; col < cols; col++) {
        final double cx = origin.x + (col * diagonal) + xOffset;
        final double cy = origin.y + (row * halfDiagonal);

        final Point top = Point.xyPoint(cx, cy - halfDiagonal);
        final Point right = Point.xyPoint(cx + halfDiagonal, cy);
        final Point bottom = Point.xyPoint(cx, cy + halfDiagonal);
        final Point left = Point.xyPoint(cx - halfDiagonal, cy);

        final bool splitDiag = _random.nextBool();

        if (splitDiag) {
          if (_palette is ImagePixelPalette) {
            Point middle1 = Point.xyPoint((top.x + right.x + bottom.x) / 3.0,
                (top.y + right.y + bottom.y) / 3.0);
            Point middle2 = Point.xyPoint((top.x + left.x + bottom.x) / 3.0,
                (top.y + left.y + bottom.y) / 3.0);

            // final image = (_palette as ImagePixelPalette).source;
            int ix1 = (middle1.x - _bounds.x).floor();
            int iy1 = (middle1.y - _bounds.y).floor();
            int ix2 = (middle2.x - _bounds.x).floor();
            int iy2 = (middle2.y - _bounds.y).floor();

            int index1 = ix1 + (_bounds.width.toInt() * iy1);
            int index2 = ix2 + (_bounds.width.toInt() * iy2);

            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index1], top, right, bottom, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index2], top, left, bottom, true);
            } else {
              _renderer.renderTriangle(_palette[index1], top, right, bottom);
              _renderer.renderTriangle(_palette[index2], top, left, bottom);
            }
          } else {
            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer).renderTriangle(
                  _palette.randomColor, top, right, bottom, true);
              (_renderer as ImageRenderer).renderTriangle(
                  _palette.randomColor, top, left, bottom, true);
            } else {
              _renderer.renderTriangle(
                  _palette.randomColor, top, right, bottom);
              _renderer.renderTriangle(_palette.randomColor, top, left, bottom);
            }
          }
        } else {
          if (_palette is ImagePixelPalette) {
            Point middle1 = Point.xyPoint((top.x + right.x + left.x) / 3.0,
                (top.y + right.y + left.y) / 3.0);
            Point middle2 = Point.xyPoint((right.x + bottom.x + left.x) / 3.0,
                (right.y + bottom.y + left.y) / 3.0);

            // final image = (_palette as ImagePixelPalette).source;
            int ix1 = (middle1.x - _bounds.x).floor();
            int iy1 = (middle1.y - _bounds.y).floor();
            int ix2 = (middle2.x - _bounds.x).floor();
            int iy2 = (middle2.y - _bounds.y).floor();

            int index1 = ix1 + (_bounds.width.toInt() * iy1);
            int index2 = ix2 + (_bounds.width.toInt() * iy2);

            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index1], top, right, left, true);
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette[index2], right, bottom, left, true);
            } else {
              _renderer.renderTriangle(_palette[index1], top, right, left);
              _renderer.renderTriangle(_palette[index2], right, bottom, left);
            }
          } else {
            if (_useGradient && _renderer is ImageRenderer) {
              (_renderer as ImageRenderer)
                  .renderTriangle(_palette.randomColor, top, right, left, true);
              (_renderer as ImageRenderer).renderTriangle(
                  _palette.randomColor, right, bottom, left, true);
            } else {
              _renderer.renderTriangle(_palette.randomColor, top, right, left);
              _renderer.renderTriangle(
                  _palette.randomColor, right, bottom, left);
            }
          }
        }
      }
    }
  }

  void defaultLayout() {
    if (_palette.count < 1) return;
    draw(Point.xyPoint(_bounds.x, _bounds.y));
  }
}
