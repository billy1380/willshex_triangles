import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
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
      paletteProvider: () async {
        final prefs = await SharedPreferences.getInstance();
        final width = prefs.getInt("image_width") ?? 800;
        final height = prefs.getInt("image_height") ?? 600;

        final image = await ImageHelper.fetchAndDecodeImage(
          "https://picsum.photos/400/300",
          width: width,
          height: height,
        );
        return ImagePixelPalette(image);
      },
    );
  }
}
