import "dart:async";

import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";

class GeneratorPaletteProvider implements PaletteProvider {
  final Future<Palette?> Function() _provider;

  GeneratorPaletteProvider(this._provider);

  @override
  Future<Palette?> get palette => _provider();
}
