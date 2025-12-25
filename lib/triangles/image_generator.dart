import "dart:async";
import "dart:math";
import "dart:typed_data";

import "package:blend_composites/blend_composites.dart";
import "package:fs_shim/fs_shim.dart";
import "package:image/image.dart" as img;
import "package:image_blend_composites/blend_composite.dart";
import "package:logging/logging.dart";
import "package:willshex_draw/willshex_draw.dart";

import "package:willshex_triangles/triangles/triangles.dart";

/// Image generator for creating triangle-based images
class ImageGenerator {
  static final Logger _log = Logger("ImageGenerator");

  static final Map<BlendingMode, BlendComposite> compositeCache = {};

  static final StringDrawer _small = StringDrawer("monaco", 20);
  static final StringDrawer _medium = StringDrawer("monaco", 50);
  static final StringDrawer _large = StringDrawer("monaco", 100);

  static final Random _rand = Random();

  /// Generate an image based on properties and write to output
  static Future<String?> generate(
    Map<String, String> properties,
    Future<Palette> Function() paletteSupplier,
    StreamSink<List<int>> output,
    Store? store, {
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    final StoreImage? image = await generateImage(
        properties, paletteSupplier, store,
        assetLoader: assetLoader, fs: fs);

    if (image != null) {
      _write(image, output);
      return image.format;
    }

    return null;
  }

  /// Generate an image object based on properties
  static Future<StoreImage?> generateImage(
    Map<String, String> properties,
    Future<Palette> Function() paletteSupplier,
    Store? store, {
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    StoreImage? loaded;

    final String? name = _stringNullable(properties,
        ImageGeneratorConfig.nameKey, ImageGeneratorConfig.defaultName);
    final int index = _integer(properties, ImageGeneratorConfig.indexKey,
        ImageGeneratorConfig.defaultIndex, 0, 100);
    final bool force = _integer(properties, ImageGeneratorConfig.forceKey,
            ImageGeneratorConfig.defaultForce, 0, 1) ==
        1;

    img.Image? composite;
    final String? texture = _stringNullable(properties,
        ImageGeneratorConfig.textureKey, ImageGeneratorConfig.defaultTexture);
    if (texture != null && texture.isNotEmpty) {
      if (assetLoader != null) {
        try {
          final Uint8List? bytes = await assetLoader(texture);
          if (bytes != null) {
            composite = img.decodeImage(bytes);
          }
        } catch (e) {
          _log.warning("Failed to load asset: $texture", e);
        }
      }

      if (composite == null && fs != null) {
        final File textureFile = fs.file(texture);
        if (await textureFile.exists()) {
          composite = img.decodeImage(await textureFile.readAsBytes());
        }
      }
    }

    if (store != null && name != null && !force) {
      loaded = store.load(name, index);
    }

    StoreImage? generated;
    if (loaded == null) {
      generated = StoreImage();

      final String format = _imageFormat(properties);
      final String? texture = _stringNullable(properties,
          ImageGeneratorConfig.textureKey, ImageGeneratorConfig.defaultTexture);
      final String type = _string(properties, ImageGeneratorConfig.typeKey,
          ImageGeneratorConfig.defaultType);
      final String palette = _string(properties,
          ImageGeneratorConfig.paletteKey, ImageGeneratorConfig.defaultPalette);
      final String blendMode = _string(
          properties,
          ImageGeneratorConfig.compositeKey,
          ImageGeneratorConfig.defaultComposite);
      final List<String>? colors = _strings(
          properties,
          ImageGeneratorConfig.paletteColoursKey,
          ImageGeneratorConfig.defaultPaletteColours);

      final int width = _integer(properties, ImageGeneratorConfig.widthKey,
          ImageGeneratorConfig.defaultWidth, 5, 2560);
      final int height = _integer(properties, ImageGeneratorConfig.heightKey,
          ImageGeneratorConfig.defaultHeight, 5, 2560);
      int numerator = _integer(properties, ImageGeneratorConfig.ratioNKey,
          ImageGeneratorConfig.defaultRatioN, 1, 10000);
      int denominator = _integer(properties, ImageGeneratorConfig.ratioDKey,
          ImageGeneratorConfig.defaultRatioD, 1, 10000);
      bool annotate = _integer(properties, ImageGeneratorConfig.annotateKey,
              ImageGeneratorConfig.defaultAnnotate, 0, 1) ==
          1;

      if (numerator > denominator) {
        final int temp = numerator;
        numerator = denominator;
        denominator = temp;
      }

      final double ratio = numerator / denominator;

      final Palette paletteObj = await _createPalette(
        PaletteType.fromString(palette),
        _toColors(colors),
        paletteSupplier,
      );

      generated.content = await _drawType(
        TrianglesType.fromString(type),
        paletteObj,
        texture,
        composite,
        BlendingMode.values.byName(blendMode),
        width,
        height,
        ratio,
        annotate,
        img.ImageFormat.values.byName(format),
      );
      generated.format = format;

      if (generated.content == null) {
        _log.warning("Looks like image was not generated");
        return null;
      } else {
        if (store != null && name != null) {
          store.save(generated, name, index);
        }
      }
    }

    return loaded ?? generated;
  }

  /// Convert color strings to Color objects
  static List<Color>? _toColors(List<String>? colors) {
    if (colors == null || colors.isEmpty) return null;
    return colors.map(_toColor).toList();
  }

  /// Convert a color string to a Color object
  static Color _toColor(String colorString) {
    if (colorString.startsWith("#")) {
      colorString = colorString.substring(1);
    }
    if (colorString.endsWith(";")) {
      colorString = colorString.substring(0, colorString.length - 1);
    }

    double red, green, blue, alpha = 1.0;

    switch (colorString.length) {
      case 8:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 24) & 0xff) / 255.0;
        green = ((val >> 16) & 0xff) / 255.0;
        blue = ((val >> 8) & 0xff) / 255.0;
        alpha = (val & 0xff) / 255.0;
        break;
      case 6:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 16) & 0xff) / 255.0;
        green = ((val >> 8) & 0xff) / 255.0;
        blue = (val & 0xff) / 255.0;
        break;
      case 3:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 8) & 0xf) / 15.0;
        green = ((val >> 4) & 0xf) / 15.0;
        blue = (val & 0xf) / 15.0;
        break;
      case 1:
        final int val = int.parse(colorString, radix: 16);
        red = green = blue = val / 15.0;
        break;
      default:
        red = green = blue = 0.0;
        break;
    }

    return Color.rgbaColor(red, green, blue, alpha);
  }

  /// Write image to output stream
  static void _write(StoreImage image, StreamSink<List<int>> output) {
    if (image.content != null) {
      output.add(image.content!);
    }
  }

  /// Draw triangle pattern based on type
  static Future<Uint8List?> _drawType(
    TrianglesType type,
    Palette palette,
    String? texture,
    img.Image? composite,
    BlendingMode mode,
    int width,
    int height,
    double r,
    bool annotate,
    img.ImageFormat format,
  ) async {
    try {
      switch (type) {
        case TrianglesType.diamondTiles:
          break;
        case TrianglesType.hTiles:
          return _drawHTiles(
              palette, composite, mode, width, height, r, annotate, format);
        case TrianglesType.overImage:
          break;
        case TrianglesType.randomJiggle:
          return _drawRandomJiggleTiles(
              palette, composite, mode, width, height, r, annotate, format);
        case TrianglesType.ribbons:
          return _drawRibbon(
              palette, composite, mode, width, height, r, annotate, format);
        case TrianglesType.squareTiles:
          return _drawSquareTiles(
              palette, composite, mode, width, height, r, annotate, format);
        case TrianglesType.tiles:
          return _drawTiles(
              palette, composite, mode, width, height, r, annotate, format);
      }
    } catch (e) {
      _log.warning("Error creating image", e);
    }
    return null;
  }

  static Uint8List _drawRibbon(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format) {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);
    ImageRenderer renderer = ImageRenderer(image);
    TriangleRibbons ribbons = TriangleRibbons.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        70,
        r);
    ribbons.defaultLayout();

    if (annotate) {
      _drawDims(width, height, image);
    }

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    return _encodeImage(image, format);
  }

  static Uint8List _drawRandomJiggleTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format) {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);
    ImageRenderer renderer = ImageRenderer(image);
    TriangleRandomJiggleTiles randomJiggles =
        TriangleRandomJiggleTiles.withRatio(
            renderer,
            palette,
            Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
            r);
    randomJiggles.defaultLayout();

    if (annotate) {
      _drawDims(width, height, image);
    }

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    return _encodeImage(image, format);
  }

  static Uint8List _drawTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format) {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleTiles tiles = TriangleTiles.withRatio(renderer, palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()), r);
    tiles.defaultLayout();

    if (annotate) {
      _drawDims(width, height, image);
    }

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    return _encodeImage(image, format);
  }

  static Uint8List _drawHTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format) {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleHTiles hTiles = TriangleHTiles.withRatio(renderer, palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()), r);
    hTiles.defaultLayout();

    if (annotate) {
      _drawDims(width, height, image);
    }

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    return _encodeImage(image, format);
  }

  static Uint8List _drawSquareTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format) {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleSquareTiles squareTiles = TriangleSquareTiles.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        r);
    squareTiles.defaultLayout();

    if (annotate) {
      _drawDims(width, height, image);
    }

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    return _encodeImage(image, format);
  }

  static img.Image _drawDims(int width, int height, img.Image image) {
    img.Image newer = img.Image(width: width, height: height, numChannels: 4);

    int dim = min(width, height);
    int th = dim ~/ 10;
    int fth = _fontSize(th);
    StringDrawer sd = _font(fth);
    String s = "${width}x$height";
    int tw = sd.getWidth(s);

    sd.draw(
        newer, s, ((width - tw) * 0.5).toInt(), ((height - fth) * 0.5).toInt());

    return _composite(image, newer, _cached(BlendingMode.add));
  }

  static img.Image _composite(
      img.Image imageA, img.Image imageB, BlendComposite composite) {
    return composite.composeImages(imageB, imageA);
  }

  static Uint8List _encodeImage(img.Image image, img.ImageFormat format) {
    if (format == img.ImageFormat.png) {
      return img.encodePng(image);
    } else {
      return img.encodeJpg(image);
    }
  }

  /// Create palette based on type
  static Future<Palette> _createPalette(
    PaletteType type,
    List<Color>? colors,
    Future<Palette> Function() paletteSupplier,
  ) async {
    switch (type) {
      case PaletteType.randomNamed:
        final palette = Palette("Random Named");
        palette.addColors([
          Color.rgbaColor(1.0, 0.0, 0.0),
          Color.rgbaColor(0.0, 1.0, 0.0),
          Color.rgbaColor(0.0, 0.0, 1.0),
          Color.rgbaColor(1.0, 1.0, 0.0),
          Color.rgbaColor(1.0, 0.0, 1.0),
        ]);
        return palette;
      case PaletteType.randomColourLovers:
        return await paletteSupplier();
      case PaletteType.randomGrayScale:
        final palette = Palette("Random Grayscale");
        for (int i = 0; i < 6; i++) {
          final double gray = _rand.nextDouble();
          palette.addColors([Color.grayscaleColor(gray)]);
        }
        return palette;
      case PaletteType.commaSeparatedList:
        final palette = Palette("Comma Separated");
        if (colors != null) {
          palette.addColors(colors);
        }
        return palette;
    }
  }

  static BlendComposite _cached(BlendingMode mode) {
    BlendComposite? composite = compositeCache[mode];

    if (composite == null) {
      compositeCache[mode] = (composite = BlendComposite.getInstance(mode));
    }

    return composite;
  }

  /// Get image format from properties
  static String _imageFormat(Map<String, String> properties) {
    return _string(properties, ImageGeneratorConfig.formatKey,
        ImageGeneratorConfig.defaultFormat);
  }

  /// Get string value from properties with validation (for non-nullable defaults)
  static String _string(
      Map<String, String> map, String key, String defaultValue,
      [List<String>? options]) {
    final String? value = map[key];
    if (value == null || value.isEmpty) return defaultValue;

    if (options != null && !options.contains(value)) {
      return defaultValue;
    }

    return value;
  }

  /// Get string value from properties with validation (for nullable defaults)
  static String? _stringNullable(
      Map<String, String> map, String key, String? defaultValue,
      [List<String>? options]) {
    final String? value = map[key];
    if (value == null || value.isEmpty) return defaultValue;

    if (options != null && !options.contains(value)) {
      return defaultValue;
    }

    return value;
  }

  /// Get string array from properties
  static List<String>? _strings(
      Map<String, String> map, String key, String? defaultValue) {
    final String? value = map[key];
    if (value == null || value.isEmpty) return null;
    return value.split(",");
  }

  /// Get integer value from properties with range validation
  static int _integer(
      Map<String, String> map, String key, int defaultValue, int min, int max) {
    final String? value = map[key];
    if (value == null || value.isEmpty) return defaultValue;

    try {
      final int intValue = int.parse(value);
      if (intValue >= min && intValue <= max) {
        return intValue;
      }
    } catch (e) {
      _log.warning("Invalid integer value for key $key: $value");
    }

    return defaultValue;
  }

  static int _fontSize(int th) {
    return th <= 20 ? 20 : (th <= 50 ? 50 : 100);
  }

  static StringDrawer _font(int size) {
    switch (size) {
      case 20:
        return _small;
      case 50:
        return _medium;
      case 100:
      default:
        return _large;
    }
  }
}
