import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HtmlColourPage extends StatelessWidget {
  static const String routePath = "/htmlcolour";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const HtmlColourPage._();
  }

  const HtmlColourPage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.navHtmlColour,
      paletteProvider: RandomNamedPaletteProvider(),
    );
  }
}
