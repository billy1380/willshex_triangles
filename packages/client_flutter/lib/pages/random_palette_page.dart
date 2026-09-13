import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class RandomPalettePage extends StatelessWidget {
  static const String routePath = "/random-palette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const RandomPalettePage._();
  }

  const RandomPalettePage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.navRandomPalette,
      paletteProvider: RandomColorPaletteProvider(),
    );
  }
}
