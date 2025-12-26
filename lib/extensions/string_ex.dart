import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/comma_separated_palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/random_grayscale_palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/random_named_palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/random_color_palette_provider.dart";
import "package:willshex_triangles/triangles/image_generator_config.dart";

extension StringEx on String? {
  List<Color> toColors(List<String>? colors) {
    if (colors == null || colors.isEmpty) return [];
    return colors.map(_toColor).toList();
  }

  Color _toColor(String colorString) {
    if (colorString.startsWith("#")) {
      colorString = colorString.substring(1);
    }
    if (colorString.endsWith(";")) {
      colorString = colorString.substring(0, colorString.length - 1);
    }

    double red, green, blue, alpha = 1.0;

    switch (colorString.length) {
      case 8:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 24) & 0xff) / 255.0;
        green = ((val >> 16) & 0xff) / 255.0;
        blue = ((val >> 8) & 0xff) / 255.0;
        alpha = (val & 0xff) / 255.0;
        break;
      case 6:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 16) & 0xff) / 255.0;
        green = ((val >> 8) & 0xff) / 255.0;
        blue = (val & 0xff) / 255.0;
        break;
      case 3:
        final int val = int.parse(colorString, radix: 16);
        red = ((val >> 8) & 0xf) / 15.0;
        green = ((val >> 4) & 0xf) / 15.0;
        blue = (val & 0xf) / 15.0;
        break;
      case 1:
        final int val = int.parse(colorString, radix: 16);
        red = green = blue = val / 15.0;
        break;
      default:
        red = green = blue = 0.0;
        break;
    }

    return Color.rgbaColor(red, green, blue, alpha);
  }

  PaletteProvider fromConfiguration(
    Map<String, String> config, {
    PaletteProvider? supplier,
  }) {
    final type = this ?? "RandomNamed";

    return switch (type) {
      "RandomNamed" => RandomNamedPaletteProvider(),
      "RandomGrayScale" => RandomGrayscalePaletteProvider(),
      "RandomColour" => supplier ?? RandomColorPaletteProvider(),
      "CommaSeparatedList" => CommaSeparatedPaletteProvider(
          config[ImageGeneratorConfig.paletteColoursKey] ?? ""),
      _ => RandomNamedPaletteProvider(),
    };
  }
}
