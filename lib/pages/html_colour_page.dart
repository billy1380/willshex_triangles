import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/named_color_palette.dart";

class HtmlColourPage extends StatelessWidget {
  static const String routePath = "/htmlcolour";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const HtmlColourPage._();
  }

  const HtmlColourPage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "HTML Colour",
      paletteProvider: () async => NamedColorPalette(),
    );
  }
}
