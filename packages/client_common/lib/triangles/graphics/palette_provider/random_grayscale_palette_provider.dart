import "package:willshex_draw/willshex_draw.dart";
import "package:client_common/constants/app_strings.dart";
import "package:client_common/triangles/graphics/palette_provider/palette_provider.dart";

class RandomGrayscalePaletteProvider implements PaletteProvider {
  RandomGrayscalePaletteProvider();

  @override
  Palette call() => Palette(AppStrings.navRandomGrayscale)
    ..addColors([
      for (int i = 0; i < 2 + (RandomHelper.random.nextInt(6)); i++)
        Color.grayscaleColor(RandomHelper.random.nextDouble())
    ]);
}
