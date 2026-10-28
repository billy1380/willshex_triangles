import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex/willshex.dart";

extension TilableImageEx on TilableImage {
  /// The names are American, as the files they are named for are.
  static const Map<String, String> _british = {
    "gray": "grey",
    "fibers": "fibres",
  };

  /// The name in sentence case. The enum prefixes names that start with a
  /// number with an "n" to be valid identifiers, which is not part of the name.
  String get label {
    final words = RegExp(r"^n\d").hasMatch(name) ? name.substring(1) : name;

    return [
      for (final word
          in StringUtils.expandByCase(words, true, false, " ").split(" "))
        _spell(word)
    ].join(" ");
  }

  static String _spell(String word) {
    final british = _british[word.toLowerCase()];
    if (british == null) return word;

    return word[0] == word[0].toUpperCase()
        ? "${british[0].toUpperCase()}${british.substring(1)}"
        : british;
  }
}
