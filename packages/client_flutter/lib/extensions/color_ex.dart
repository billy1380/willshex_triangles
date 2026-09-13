import "package:flutter/painting.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;

extension ColorEx on ws.Color {
  Color toColor() {
    return Color.fromARGB(
      (alpha * 255).toInt(),
      (red * 255).toInt(),
      (green * 255).toInt(),
      (blue * 255).toInt(),
    );
  }
}
