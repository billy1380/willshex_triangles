import "package:willshex_draw/willshex_draw.dart";
import "package:client_common/triangles/graphics/named_color_palette.dart";
import "package:client_common/triangles/graphics/palette_provider/palette_provider.dart";

class RandomNamedPaletteProvider implements PaletteProvider {
  @override
  Palette call() => NamedColorPalette();
}
