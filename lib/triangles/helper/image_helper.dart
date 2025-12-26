import "dart:typed_data";

import "package:http/http.dart" as http;
import "package:image/image.dart" as img;

/// Helper functions for fetching and decoding images
class ImageHelper {
  /// Fetches an image from a URL and decodes it
  /// If width and height are provided, they are used in the URL
  static Future<img.Image> fetchAndDecodeImage(
    String url, {
    int? width,
    int? height,
  }) async {
    // If dimensions are provided and URL is Lorem Picsum, use them
    String finalUrl = url;
    if (width != null && height != null && url.contains("picsum.photos")) {
      finalUrl = "https://picsum.photos/$width/$height";
    }

    final response = await http
        .get(Uri.parse(finalUrl))
        .timeout(const Duration(seconds: 10));

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
