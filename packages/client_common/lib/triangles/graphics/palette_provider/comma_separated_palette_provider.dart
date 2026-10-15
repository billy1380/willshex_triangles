import "package:triangles_common/constants/app_strings.dart";
import "package:triangles_common/extensions/string_ex.dart";
import "package:triangles_common/triangles/graphics/palette_provider/fixed_palette_provider.dart";

class CommaSeparatedPaletteProvider extends FixedPaletteProvider {
  CommaSeparatedPaletteProvider(String colors)
      : super(
          colors.toColors(colors.split(",")),
          AppStrings.paletteCommaSeparated,
        );
}
