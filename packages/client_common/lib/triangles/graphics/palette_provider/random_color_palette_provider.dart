import "package:willshex_draw/willshex_draw.dart";
import "package:client_common/triangles/graphics/palette_provider/palette_provider.dart";
import "package:client_common/triangles/graphics/random_color_palette.dart";

class RandomColorPaletteProvider implements PaletteProvider {
  @override
  Palette? call() => RandomColorPalette()..generateRandomColors();
}
