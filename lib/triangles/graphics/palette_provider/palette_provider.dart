import "dart:async";

import "package:willshex_draw/willshex_draw.dart";

abstract class PaletteProvider {
  FutureOr<Palette?> get palette;
}
