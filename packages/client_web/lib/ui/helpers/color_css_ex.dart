import "package:willshex_draw/willshex_draw.dart" as ws;

extension ColorCssEx on ws.Color {
  String toCssRgba() {
    final r = (red * 255).round();
    final g = (green * 255).round();
    final b = (blue * 255).round();
    return "rgba($r, $g, $b, $alpha)";
  }

  String toHex() {
    final r = (red * 255).round().toRadixString(16).padLeft(2, "0");
    final g = (green * 255).round().toRadixString(16).padLeft(2, "0");
    final b = (blue * 255).round().toRadixString(16).padLeft(2, "0");
    return "#$r$g$b";
  }
}
