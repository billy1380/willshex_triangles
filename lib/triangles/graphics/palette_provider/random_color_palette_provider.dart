import "dart:async";

import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/random_color_palette.dart";

class RandomColorPaletteProvider implements PaletteProvider {
  @override
  FutureOr<Palette> get palette {
    final palette = RandomColorPalette();
    palette.generateRandomColors();
    return palette;
  }
}
