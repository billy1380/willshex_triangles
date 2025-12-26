import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";

class RandomGrayscalePaletteProvider implements PaletteProvider {
  RandomGrayscalePaletteProvider();

  @override
  Palette call() => Palette("Random Grayscale")
    ..addColors([
      for (int i = 0; i < 2 + (RandomHelper.random.nextInt(6)); i++)
        Color.grayscaleColor(RandomHelper.random.nextDouble())
    ]);
}
