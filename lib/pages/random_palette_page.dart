import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/random_color_palette.dart";

class RandomPalettePage extends StatelessWidget {
  static const String routePath = "/random-palette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const RandomPalettePage._();
  }

  const RandomPalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "Random Palette",
      paletteProvider: (_, __) async {
        final palette = RandomColorPalette();
        palette.generateRandomColors();
        return palette;
      },
    );
  }
}
