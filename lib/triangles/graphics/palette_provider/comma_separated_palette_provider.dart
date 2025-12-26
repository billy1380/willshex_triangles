import "package:willshex_triangles/extensions/string_ex.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/fixed_palette_provider.dart";

class CommaSeparatedPaletteProvider extends FixedPaletteProvider {
  CommaSeparatedPaletteProvider(String colors)
      : super(
          colors.toColors(colors.split(",")),
          "Comma Separated",
        );
}
