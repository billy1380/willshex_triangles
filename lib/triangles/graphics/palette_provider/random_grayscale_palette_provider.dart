import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/fixed_palette_provider.dart";

class RandomGrayscalePaletteProvider extends FixedPaletteProvider {
  RandomGrayscalePaletteProvider()
      : super([
          for (int i = 0; i < 6; i++)
            Color.grayscaleColor(Palette.random.nextDouble())
        ], "Random Grayscale");
}
