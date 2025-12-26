import "dart:typed_data";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:http/http.dart" as http;
import "package:image/image.dart" as img;
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";

class ImagePalettePage extends StatelessWidget {
  static const String routePath = "/imagepalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImagePalettePage._();
  }

  const ImagePalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "From Image",
      paletteProvider: () async {
        final image =
            await _fetchAndDecodeImage("https://picsum.photos/400/300");
        return ImagePixelPalette(image);
      },
    );
  }

  static Future<img.Image> _fetchAndDecodeImage(String url) async {
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch image: HTTP ${response.statusCode}");
    }

    final decodedImage =
        img.decodeImage(Uint8List.fromList(response.bodyBytes));
    if (decodedImage == null) {
      throw Exception("Failed to decode image");
    }

    return decodedImage;
  }
}
