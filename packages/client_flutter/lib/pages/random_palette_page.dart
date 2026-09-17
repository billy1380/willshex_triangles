import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class RandomPalettePage extends StatelessWidget {
  static const String routePath = "/random-palette";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  RandomPalettePage({
    this.showDrawer = true,
    this.showAppBar = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  static Widget builder(BuildContext context, GoRouterState state) {
    return RandomPalettePage();
  }

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.navRandomPalette,
      paletteProvider: RandomColorPaletteProvider(),
      showDrawer: showDrawer,
      showAppBar: showAppBar,
      paths: paths,
    );
  }
}
