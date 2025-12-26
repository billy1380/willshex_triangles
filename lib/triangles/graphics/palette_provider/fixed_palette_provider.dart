import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";

class FixedPaletteProvider implements PaletteProvider {
  late final Palette _palette;

  FixedPaletteProvider([List<Color>? colors, String? name])
      : _palette = Palette(name ?? "Fixed")..addColors(colors ?? []);

  @override
  Palette call() => _palette;
}
