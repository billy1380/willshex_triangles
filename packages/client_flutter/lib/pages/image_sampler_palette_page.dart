import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class ImageSamplerPalettePage extends StatelessWidget {
  static const String routePath = "/imagesamplerpalette";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  ImageSamplerPalettePage({
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
    return ImageSamplerPalettePage();
  }

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.imageSamplerPalette,
      generatorType: GeneratorType.imageSampler,
      showDrawer: showDrawer,
      showAppBar: showAppBar,
      paths: paths,
    );
  }
}
