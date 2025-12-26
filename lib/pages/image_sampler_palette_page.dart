import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/canvas_sample_palette.dart";
import "package:willshex_triangles/triangles/helper/image_helper.dart";
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
      title: "Image Sampler Palette",
      paletteProvider: (width, height) async {
        final image = await ImageHelper.fetchAndDecodeImage(
          "https://picsum.photos/$width/$height",
          width: width,
          height: height,
        );
        return CanvasSamplePalette.generate(image.toArgbPixels());
      },
    );
  }
}
