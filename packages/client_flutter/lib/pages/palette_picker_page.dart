import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/palette_picker_dialog.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class PalettePickerPage extends StatelessWidget {
  static const String routePath = "/palettepicker";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;

  PalettePickerPage({
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
    return PalettePickerPage();
  }

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: AppStrings.navPalettePicker,
      paletteProvider: GeneratorPaletteProvider(() async => null),
      showDrawer: showDrawer,
      showAppBar: showAppBar,
      paths: paths,
      customPalettePicker: (context) => showDialog<ws.Palette>(
        context: context,
        barrierDismissible: true,
        builder: (context) => const PalettePickerDialog(),
      ),
    );
  }
}
