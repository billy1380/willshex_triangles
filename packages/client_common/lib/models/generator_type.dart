import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/models/generator_settings.dart";
import "package:client_common/triangles/triangles.dart";

enum GeneratorType {
  palettePicker(
    title: "Palette Picker",
    routePath: "/palettepicker",
  ),
  htmlColour(
    title: "HTML Colour",
    routePath: "/htmlcolour",
  ),
  randomPalette(
    title: "Random Palette",
    routePath: "/random-palette",
  ),
  randomGrayscale(
    title: "Random Grayscale",
    routePath: "/random-grayscale-palette",
  ),
  imagePalette(
    title: "Image",
    routePath: "/imagepalette",
  ),
  imageSampler(
    title: "Image Sampler",
    routePath: "/imagesamplerpalette",
  );

  final String title;
  final String routePath;

  const GeneratorType({
    required this.title,
    required this.routePath,
  });

  static GeneratorType? fromRoutePath(String path) {
    for (final type in GeneratorType.values) {
      if (path.startsWith(type.routePath)) return type;
    }
    return null;
  }

  PaletteProvider createProvider({
    Future<ws.Palette?> Function()? pickerCallback,
    GeneratorSettings? settings,
  }) {
    final w = settings?.width ?? ImageGeneratorConfig.defaultWidth;
    final h = settings?.height ?? ImageGeneratorConfig.defaultHeight;

    switch (this) {
      case GeneratorType.palettePicker:
        return GeneratorPaletteProvider(() async {
          if (pickerCallback != null) {
            return await pickerCallback();
          }
          return null;
        });
      case GeneratorType.htmlColour:
        return RandomNamedPaletteProvider();
      case GeneratorType.randomPalette:
        return RandomColorPaletteProvider();
      case GeneratorType.randomGrayscale:
        return RandomGrayscalePaletteProvider();
      case GeneratorType.imagePalette:
        return GeneratorPaletteProvider(() async {
          final url = "https://picsum.photos/$w/$h";
          final image = await ImageHelper.fetchAndDecodeImage(
            url,
            width: w,
            height: h,
          );
          return ImagePixelPalette(image);
        });
      case GeneratorType.imageSampler:
        return GeneratorPaletteProvider(() async {
          final url = "https://picsum.photos/$w/$h";
          final image = await ImageHelper.fetchAndDecodeImage(
            url,
            width: w,
            height: h,
          );
          return CanvasSamplePalette.generate(
            image.toArgbPixels(),
            source: image,
          );
        });
    }
  }
}
