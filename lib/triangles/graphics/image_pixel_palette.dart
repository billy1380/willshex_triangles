import "package:image/image.dart" as img;
import "package:willshex_draw/willshex_draw.dart";

/// A palette that samples colors directly from an image's pixel data
/// This palette pretends to have a reasonable count but samples from the image
/// based on the requested index mapped to pixel positions
class ImagePixelPalette extends Palette {
  final img.Image _image;
  final int _width;
  final int _height;

  ImagePixelPalette(this._image)
      : _width = _image.width,
        _height = _image.height {
    // Pre-populate with a sample of colors from the image for compatibility
    // Sample every Nth pixel to get a representative palette
    final sampleRate = 20; // Sample every 20th pixel
    for (int y = 0; y < _height; y += sampleRate) {
      for (int x = 0; x < _width; x += sampleRate) {
        final pixel = _image.getPixel(x, y);
        addColors([
          Color.rgbaColor(
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
            pixel.a / 255.0,
          )
        ]);
      }
    }
  }

  @override
  int get count => super.count; // Now returns the count of sampled colors

  @override
  Color operator [](int index) {
    // For direct access, sample from the actual image pixels
    // Map the index to a position in the image
    final totalPixels = _width * _height;
    final pixelIndex = index % totalPixels;

    int y = (pixelIndex / _width).floor();
    int x = pixelIndex - (y * _width);

    // Clamp to valid ranges
    x = x.clamp(0, _width - 1);
    y = y.clamp(0, _height - 1);

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
