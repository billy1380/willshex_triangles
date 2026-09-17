import "package:client_common/constants/app_strings.dart";
import "package:client_common/extensions/string_ex.dart";
import "package:client_common/triangles/graphics/palette_provider/fixed_palette_provider.dart";

class CommaSeparatedPaletteProvider extends FixedPaletteProvider {
  CommaSeparatedPaletteProvider(String colors)
      : super(
          colors.toColors(colors.split(",")),
          AppStrings.paletteCommaSeparated,
        );
}
