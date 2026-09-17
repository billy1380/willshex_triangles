import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class ImagePalettePage extends StatelessWidget {
  static const String routePath = "/imagepalette";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  ImagePalettePage({
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
    return ImagePalettePage();
  }

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.imagePalette,
      generatorType: GeneratorType.imagePalette,
      showDrawer: showDrawer,
      showAppBar: showAppBar,
      paths: paths,
    );
  }
}
