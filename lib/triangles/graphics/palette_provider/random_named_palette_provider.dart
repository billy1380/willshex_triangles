import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/named_color_palette.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";

class RandomNamedPaletteProvider implements PaletteProvider {
  @override
  Palette get palette => NamedColorPalette();
}
