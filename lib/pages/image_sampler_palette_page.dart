import "dart:typed_data";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:http/http.dart" as http;
import "package:image/image.dart" as img;
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/canvas_sample_palette.dart";
import "package:willshex_triangles/triangles/helper/image_pixel_extension.dart";

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
        final response = await http
            .get(Uri.parse("https://picsum.photos/400/300"))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode != 200) {
          throw Exception("Failed to fetch image: HTTP ${response.statusCode}");
        }

        final decodedImage =
            img.decodeImage(Uint8List.fromList(response.bodyBytes));
        if (decodedImage == null) {
          throw Exception("Failed to decode image");
        }

        return CanvasSamplePalette.generate(decodedImage.toArgbPixels());
      },
    );
  }
}
