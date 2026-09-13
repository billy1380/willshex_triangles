import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/palette_picker_dialog.dart";
import "package:client_flutter/parts/triangle_generator_page.dart";

class PalettePickerPage extends StatelessWidget {
  static const String routePath = "/palettepicker";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const PalettePickerPage._();
  }

  const PalettePickerPage._();

  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "Palette Picker",
      paletteProvider: GeneratorPaletteProvider(() async => null),
      customPalettePicker: (context) => showDialog<ws.Palette>(
        context: context,
        barrierDismissible: true,
        builder: (context) => const PalettePickerDialog(),
      ),
    );
  }
}
