import "dart:async";
import "dart:math";
import "dart:typed_data";

import "package:blend_composites/blend_composites.dart";
import "package:fs_shim/fs_shim.dart";
import "package:image/image.dart" as img;
import "package:image_blend_composites/blend_composite.dart";
import "package:logging/logging.dart";
import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";
import "package:willshex_triangles/triangles/triangles.dart";

/// Image generator for creating triangle-based images
class ImageGenerator {
  static final Logger _log = Logger("ImageGenerator");

  static final Map<BlendingMode, BlendComposite> compositeCache = {};

  static final Map<int, StringDrawer> _fontCache = {};

  /// Generate an image based on properties and write to output
  static Future<String?> generate(
    Map<String, String> properties,
    PaletteProvider paletteProvider,
    StreamSink<List<int>> output,
    Store? store, {
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    final StoreImage? image = await generateImage(
        properties, paletteProvider, store,
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
    PaletteProvider paletteProvider,
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

    if (composite != null && composite.numChannels != 4) {
      composite = composite.convert(numChannels: 4);
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
      final String blendMode = _string(
          properties,
          ImageGeneratorConfig.compositeKey,
          ImageGeneratorConfig.defaultComposite);

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
      bool addGradients = _integer(
              properties,
              ImageGeneratorConfig.addGameGradientsKey,
              ImageGeneratorConfig.defaultAddGameGradients,
              0,
              1) ==
          1;

      if (numerator > denominator) {
        final int temp = numerator;
        numerator = denominator;
        denominator = temp;
      }

      final double ratio = numerator / denominator;

      final Palette? palette = await paletteProvider();

      if (palette == null) {
        _log.warning("Palette provider returned null palette");
        return null;
      }

      generated.content = await _drawType(
        TrianglesType.fromString(type),
        palette,
        texture,
        composite,
        BlendingMode.values.byName(blendMode),
        width,
        height,
        ratio,
        annotate,
        img.ImageFormat.values.byName(format),
        addGradients,
        assetLoader: assetLoader,
        fs: fs,
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
    bool addGradients, {
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    try {
      switch (type) {
        case TrianglesType.diamondTiles:
          return _drawDiamondTiles(palette, composite, mode, width, height, r,
              annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
        case TrianglesType.hTiles:
          return _drawHTiles(palette, composite, mode, width, height, r,
              annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
        case TrianglesType.randomJiggle:
          return _drawRandomJiggleTiles(palette, composite, mode, width, height,
              r, annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
        case TrianglesType.ribbons:
          return _drawRibbon(palette, composite, mode, width, height, r,
              annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
        case TrianglesType.squareTiles:
          return _drawSquareTiles(palette, composite, mode, width, height, r,
              annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
        case TrianglesType.tiles:
          return _drawTiles(palette, composite, mode, width, height, r,
              annotate, format, addGradients,
              assetLoader: assetLoader, fs: fs);
      }
    } catch (e) {
      _log.warning("Error creating image", e);
    }
    return null;
  }

  static Future<Uint8List> _drawRibbon(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);
    ImageRenderer renderer = ImageRenderer(image);
    TriangleRibbons ribbons = TriangleRibbons.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        70,
        r,
        addGradients);
    ribbons.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<Uint8List> _drawRandomJiggleTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);
    ImageRenderer renderer = ImageRenderer(image);
    TriangleRandomJiggleTiles randomJiggles =
        TriangleRandomJiggleTiles.withRatio(
            renderer,
            palette,
            Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
            r,
            addGradients);
    randomJiggles.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<Uint8List> _drawTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleTiles tiles = TriangleTiles.withRatio(
      renderer,
      palette,
      Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
      r,
      addGradients,
    );
    tiles.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<Uint8List> _drawHTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleHTiles hTiles = TriangleHTiles.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        r,
        addGradients);
    hTiles.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<Uint8List> _drawDiamondTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleDiamondTiles diamondTiles = TriangleDiamondTiles.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        r,
        addGradients);
    diamondTiles.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<Uint8List> _drawSquareTiles(
      Palette palette,
      img.Image? composite,
      BlendingMode mode,
      int width,
      int height,
      double r,
      bool annotate,
      img.ImageFormat format,
      bool addGradients,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image image = img.Image(width: width, height: height, numChannels: 4);

    ImageRenderer renderer = ImageRenderer(image);

    TriangleSquareTiles squareTiles = TriangleSquareTiles.withRatio(
        renderer,
        palette,
        Rect.xyWidthHeightRect(0, 0, width.toDouble(), height.toDouble()),
        r,
        addGradients);
    squareTiles.defaultLayout();

    if (composite != null) {
      image = _composite(image, composite, _cached(mode));
    }

    if (annotate) {
      image = await _drawDims(width, height, image,
          assetLoader: assetLoader, fs: fs);
    }

    return _encodeImage(image, format);
  }

  static Future<img.Image> _drawDims(int width, int height, img.Image image,
      {Future<Uint8List?> Function(String path)? assetLoader,
      FileSystem? fs}) async {
    img.Image newer = img.Image(width: width, height: height, numChannels: 4);

    int dim = min(width, height);
    int th = dim ~/ 10;
    int fth = _fontSize(th);
    StringDrawer sd = await _font(fth, assetLoader: assetLoader, fs: fs);
    String s = "${width}x$height";
    int tw = sd.getWidth(s);

    int tx = ((width - tw) * 0.5).toInt();
    int ty = ((height - fth) * 0.5).toInt();

    final result = _composite(newer, image, _cached(BlendingMode.normal));
    sd.draw(result, s, tx, ty);

    return result;
  }

  static img.Image _composite(
      img.Image imageA, img.Image imageB, BlendComposite composite) {
    img.Image background = imageB;

    if (imageA.width != imageB.width || imageA.height != imageB.height) {
      background = _tile(imageB, imageA.width, imageA.height);
    }

    return composite.composeImages(background, imageA);
  }

  static img.Image _tile(img.Image texture, int width, int height) {
    final img.Image tiled =
        img.Image(width: width, height: height, numChannels: 4);

    for (int y = 0; y < height; y += texture.height) {
      for (int x = 0; x < width; x += texture.width) {
        img.compositeImage(tiled, texture, dstX: x, dstY: y);
      }
    }

    return tiled;
  }

  static Uint8List _encodeImage(img.Image image, img.ImageFormat format) {
    if (format == img.ImageFormat.png) {
      return img.encodePng(image);
    } else {
      return img.encodeJpg(image);
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

  static Future<StringDrawer> _font(
    int size, {
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    int targetSize;
    if (size <= 20) {
      targetSize = 20;
    } else if (size <= 50) {
      targetSize = 50;
    } else {
      targetSize = 100;
    }

    if (!_fontCache.containsKey(targetSize)) {
      final drawer = StringDrawer("monaco", targetSize);
      await drawer.load(assetLoader: assetLoader, fs: fs);
      _fontCache[targetSize] = drawer;
    }

    return _fontCache[targetSize]!;
  }
}
