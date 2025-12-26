import "dart:typed_data";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:http/http.dart" as http;
import "package:image/image.dart" as img;
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/canvas_sample_palette.dart";

class ImageSamplerPalettePage extends StatelessWidget {
  static const String routePath = "/imagesamplerpalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImageSamplerPalettePage._();
  }

  const ImageSamplerPalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "From Image",
      paletteProvider: () async {
        // Try to fetch a random image from a service
        // Using Lorem Picsum as a simple placeholder image service
        final response = await http.get(
          Uri.parse("https://picsum.photos/400/300"),
        );

        if (response.statusCode == 200) {
          // Decode the image
          final imageBytes = response.bodyBytes;
          final decodedImage = img.decodeImage(Uint8List.fromList(imageBytes));

          if (decodedImage != null) {
            // Extract pixels (RGBA format)
            final pixels = <int>[];
            for (int y = 0; y < decodedImage.height; y++) {
              for (int x = 0; x < decodedImage.width; x++) {
                final pixel = decodedImage.getPixel(x, y);
                // Convert pixel to ARGB int format
                final a = pixel.a.toInt();
                final r = pixel.r.toInt();
                final g = pixel.g.toInt();
                final b = pixel.b.toInt();
                pixels.add((a << 24) | (r << 16) | (g << 8) | b);
              }
            }

            // Generate palette from pixels
            return CanvasSamplePalette.generate(pixels);
          }
        }

        // Fallback: return a simple default palette if fetch fails
        throw Exception("Failed to fetch or process image");
      },
    );
  }
}
