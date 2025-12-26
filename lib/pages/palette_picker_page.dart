import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/parts/palette_picker_dialog.dart";
import "package:willshex_triangles/parts/triangle_generator_page.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/generator_palette_provider.dart";

class PalettePickerPage extends StatefulWidget {
  static const String routePath = "/palettepicker";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const PalettePickerPage();
  }

  const PalettePickerPage({super.key});

  @override
  State<PalettePickerPage> createState() => _PalettePickerPageState();
}

class _PalettePickerPageState extends State<PalettePickerPage> {
  @override
  Widget build(BuildContext context) {
    return TriangleGeneratorPage(
      title: "Palette Picker",
      paletteProvider: GeneratorPaletteProvider(() async {
        final Palette? palette = await showDialog<Palette>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const PalettePickerDialog(),
        );

        return palette;
      }),
    );
  }
}
