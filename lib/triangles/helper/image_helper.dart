import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:image/image.dart" as img;

/// Helper functions for fetching and decoding images
class ImageHelper {
  /// Fetches an image from a URL and decodes it
  static Future<img.Image> fetchAndDecodeImage(String url) async {
    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch image: HTTP ${response.statusCode}");
    }

    final decodedImage =
        img.decodeImage(Uint8List.fromList(response.bodyBytes));
    if (decodedImage == null) {
      throw Exception("Failed to decode image");
    }

    return decodedImage;
  }
}
