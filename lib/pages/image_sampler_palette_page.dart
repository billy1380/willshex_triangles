import "dart:typed_data";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:http/http.dart" as http;
import "package:image/image.dart" as img;
import "package:logging/logging.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/canvas_sample_palette.dart";

class ImageSamplerPalettePage extends StatelessWidget {
  static const String routePath = "/imagesamplerpalette";
  static final Logger _log = Logger("ImageSamplerPalettePage");

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImageSamplerPalettePage._();
  }

  const ImageSamplerPalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "From Image",
      paletteProvider: () async {
        try {
          _log.info("Fetching random image...");
          final response = await http
              .get(
                Uri.parse("https://picsum.photos/400/300"),
              )
              .timeout(const Duration(seconds: 10));

          if (response.statusCode != 200) {
            throw Exception("HTTP ${response.statusCode}");
          }

          _log.info("Decoding image...");
          final imageBytes = response.bodyBytes;
          final decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

          if (decodedImage == null) {
            throw Exception("Failed to decode image");
          }

          _log.info(
              "Extracting pixels from ${decodedImage.width}x${decodedImage.height} image...");
          final pixels = <int>[];
          for (int y = 0; y < decodedImage.height; y++) {
            for (int x = 0; x < decodedImage.width; x++) {
              final pixel = decodedImage.getPixel(x, y);
              final a = pixel.a.toInt();
              final r = pixel.r.toInt();
              final g = pixel.g.toInt();
              final b = pixel.b.toInt();
              pixels.add((a << 24) | (r << 16) | (g << 8) | b);
            }
          }

          _log.info("Generating palette from ${pixels.length} pixels...");
          final palette = CanvasSamplePalette.generate(pixels);
          _log.info("Generated palette with ${palette.count} colors");
          return palette;
        } catch (e, stack) {
          _log.severe("Error in palette provider: $e");
          _log.severe("Stack trace: $stack");
          rethrow;
        }
      },
    );
  }
}
