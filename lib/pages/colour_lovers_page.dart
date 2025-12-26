import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/colourlovers/colour_lovers_client_palette.dart";

class ColourLoversPage extends StatelessWidget {
  static const String routePath = "/colourlovers";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ColourLoversPage._();
  }

  const ColourLoversPage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "COLOURLovers Palette",
      paletteProvider: (_, __) async {
        final palette = ColourLoversClientPalette();
        await palette.getColors("random", 0, 1);
        return palette;
      },
    );
  }
}
