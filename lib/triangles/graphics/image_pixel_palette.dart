import "package:image/image.dart" as img;
import "package:willshex_draw/willshex_draw.dart";

/// A palette that samples colors directly from an image's pixel data
class ImagePixelPalette extends Palette {
  final img.Image _image;
  final int _width;
  final int _height;

  ImagePixelPalette(this._image)
      : _width = _image.width,
        _height = _image.height;

  @override
  int get count => _width * _height;

  @override
  Color operator [](int index) {
    // Convert linear index to x,y coordinates
    int y = (index / _width).floor();
    int x = index - (y * _width);

    // Clamp to valid ranges
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x >= _width) x = _width - 1;
    if (y >= _height) y = _height - 1;

    // Get pixel from image
    final pixel = _image.getPixel(x, y);

    return Color.rgbaColor(
      pixel.r / 255.0,
      pixel.g / 255.0,
      pixel.b / 255.0,
      pixel.a / 255.0,
    );
  }
}
