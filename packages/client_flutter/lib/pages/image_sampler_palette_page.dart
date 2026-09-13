import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class ImageSamplerPalettePage extends StatelessWidget {
  static const String routePath = "/imagesamplerpalette";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const ImageSamplerPalettePage._();
  }

  const ImageSamplerPalettePage._();

  @override
  Widget build(BuildContext context) {
    return const TriangleGeneratorPage(
      title: AppStrings.imageSamplerPalette,
      generatorType: GeneratorType.imageSampler,
    );
  }
}
