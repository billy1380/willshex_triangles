import "dart:async";

import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";

typedef GeneratorPalette = FutureOr<Palette?> Function();

class GeneratorPaletteProvider implements PaletteProvider {
  final GeneratorPalette _generator;

  GeneratorPaletteProvider(this._generator);

  @override
  FutureOr<Palette?> call() => _generator();
}
