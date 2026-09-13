import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/constants/app_strings.dart";
import "package:client_common/models/generator_settings.dart";
import "package:client_common/triangles/triangles.dart";

enum GeneratorType {
  palettePicker(
    title: AppStrings.navPalettePicker,
    routePath: "/palettepicker",
  ),
  htmlColour(
    title: AppStrings.navHtmlColour,
    routePath: "/htmlcolour",
  ),
  randomPalette(
    title: AppStrings.navRandomPalette,
    routePath: "/random-palette",
  ),
  randomGrayscale(
    title: AppStrings.navRandomGrayscale,
    routePath: "/random-grayscale-palette",
  ),
  imagePalette(
    title: AppStrings.imagePalette,
    routePath: "/imagepalette",
  ),
  imageSampler(
    title: AppStrings.imageSamplerPalette,
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
    GeneratorSettings Function()? getSettings,
  }) {
    GeneratorSettings currentSettings() =>
        getSettings?.call() ?? settings ?? const GeneratorSettings();

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
          final s = currentSettings();
          final w = s.width;
          final h = s.height;
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
          final s = currentSettings();
          final w = s.width;
          final h = s.height;
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
