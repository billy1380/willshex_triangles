import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/random_grayscale_palette_provider.dart";

class RandomGrayscalePalettePage extends StatelessWidget {
  static const String routePath = "/random-grayscale-palette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const RandomGrayscalePalettePage._();
  }

  const RandomGrayscalePalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "Random Grayscale",
      paletteProvider: RandomGrayscalePaletteProvider(),
    );
  }
}
