/// Image data class for storing generated images
class StoreImage {
  List<int>? content;
  String? format;

  StoreImage({this.content, this.format});
}

/// Store interface for saving and loading generated images
abstract class Store {
  static const String allowed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_";

  /// Load an image by name and index
  StoreImage? load(String name, int index);

  /// Save an image with name and index
  void save(StoreImage image, String name, int index);

  /// Sanitize a name to only contain allowed characters
  static String? sanitizeName(String? name) {
    String? validName;

    if (name != null && name.isNotEmpty) {
      final StringBuffer buffer = StringBuffer();
      final int count = name.length;
      
      for (int i = 0; i < count; i++) {
        final String s = name.substring(i, i + 1);
        if (allowed.contains(s)) {
          buffer.write(s);
        }
      }

      if (buffer.isNotEmpty) {
        validName = buffer.toString();
      }
    }

    return validName;
  }
} 