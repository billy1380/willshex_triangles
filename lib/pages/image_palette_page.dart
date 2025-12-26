import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/image_pixel_palette.dart";
import "package:willshex_triangles/triangles/helper/image_helper.dart";

class ImagePalettePage extends StatelessWidget {
  static const String routePath = "/imagepalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImagePalettePage._();
  }

  const ImagePalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "Image Palette",
      paletteProvider: (width, height) async {
        final image = await ImageHelper.fetchAndDecodeImage(
          "https://picsum.photos/$width/$height",
          width: width,
          height: height,
        );
        return ImagePixelPalette(image);
      },
    );
  }
}
