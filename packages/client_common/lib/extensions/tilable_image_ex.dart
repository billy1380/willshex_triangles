import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex/willshex.dart";

extension TilableImageEx on TilableImage {
  /// The name in sentence case. The enum prefixes names that start with a
  /// number with an "n" to be valid identifiers, which is not part of the name.
  String get label {
    final words = RegExp(r"^n\d").hasMatch(name) ? name.substring(1) : name;

    return StringUtils.expandByCase(words, true, false, " ");
  }
}
