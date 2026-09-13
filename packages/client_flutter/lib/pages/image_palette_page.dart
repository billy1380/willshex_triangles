import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class ImagePalettePage extends StatelessWidget {
  static const String routePath = "/imagepalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImagePalettePage._();
  }

  const ImagePalettePage._();

  @override
  Widget build(BuildContext context) {
    return const TriangleGeneratorPage(
      title: AppStrings.imagePalette,
      generatorType: GeneratorType.imagePalette,
    );
  }
}
