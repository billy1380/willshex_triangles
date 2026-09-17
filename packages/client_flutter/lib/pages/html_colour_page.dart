import "package:client_common/client_common.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HtmlColourPage extends StatelessWidget {
  static const String routePath = "/htmlcolour";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  HtmlColourPage({
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
    return HtmlColourPage();
  }

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.navHtmlColour,
      paletteProvider: RandomNamedPaletteProvider(),
      showDrawer: showDrawer,
      showAppBar: showAppBar,
      paths: paths,
    );
  }
}
