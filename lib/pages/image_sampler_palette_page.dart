import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/canvas_sample_palette.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/generator_palette_provider.dart";
import "package:willshex_triangles/triangles/helper/image_helper.dart";
import "package:willshex_triangles/triangles/helper/image_pixel_extension.dart";
import "package:willshex_triangles/triangles/image_generator_config.dart";

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
      paletteProvider: GeneratorPaletteProvider(() async {
        final prefs = await SharedPreferences.getInstance();

        final width =
            prefs.getInt("image_width") ?? ImageGeneratorConfig.defaultWidth;
        final height =
            prefs.getInt("image_height") ?? ImageGeneratorConfig.defaultHeight;

        final image = await ImageHelper.fetchAndDecodeImage(
          "https://picsum.photos/$width/$height",
          width: width,
          height: height,
        );
        return CanvasSamplePalette.generate(
          image.toArgbPixels(),
          source: image,
        );
      }),
    );
  }
}
