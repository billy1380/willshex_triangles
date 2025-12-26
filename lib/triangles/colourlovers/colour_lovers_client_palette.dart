import "dart:async";
import "dart:convert";
import "dart:io";

import "package:http/http.dart" as http;
import "package:logging/logging.dart";
import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/triangles/graphics/random_color_palette.dart";

import "../graphics/color_utils.dart";

/// Client for fetching color palettes from COLOURlovers API
class ColourLoversClientPalette extends RandomColorPalette {
  static final Logger _log = Logger("ColourLoversClientPalette");

  /// Base URLs for the COLOURlovers API (try HTTPS first, then HTTP)
  static const List<String> _baseUrls = [
    "https://www.colourlovers.com/api",
    "http://www.colourlovers.com/api",
  ];

  /// Constructor for the COLOURlovers client palette
  ColourLoversClientPalette() : super("COLOURlovers Palette");

  /// Test network connectivity to COLOURlovers API
  Future<bool> testConnection() async {
    for (final String baseUrl in _baseUrls) {
      try {
        final http.Client client = http.Client();
        final response = await client.get(
          Uri.parse(
              "$baseUrl/palettes/random?format=json&numResults=1&resultOffset=0"),
          headers: {
            "User-Agent": "WillshexTriangles/1.0",
            "Accept": "application/json",
          },
        ).timeout(const Duration(seconds: 10));

        client.close();

        if (response.statusCode == 200) {
          _log.info("Network connection test successful with $baseUrl");
          return true;
        } else {
          _log.warning(
              "Network connection test failed with $baseUrl: HTTP ${response.statusCode}");
        }
      } catch (e) {
        _log.severe("Network connection test failed with $baseUrl: $e");
      }
    }
    return false;
  }

  /// Fetch colors from COLOURlovers API
  ///
  /// [type] - The type of palette to fetch (e.g., 'random', 'top', 'new')
  /// [numResults] - Number of results to fetch
  /// [resultOffset] - Offset for pagination
  Future<void> fetchColors(
      String type, int resultOffset, int numResults) async {
    for (final String baseUrl in _baseUrls) {
      try {
        final String url =
            "$baseUrl/palettes/$type?format=json&numResults=$numResults&resultOffset=$resultOffset";

        _log.info("Fetching colors from: $url");

        // Create HTTP client with timeout and proper headers
        final http.Client client = http.Client();

        final http.Response response = await client.get(
          Uri.parse(url),
          headers: {
            "User-Agent":
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept": "application/json, text/plain, */*",
            "Accept-Language": "en-US,en;q=0.9",
            "Accept-Encoding": "gzip, deflate, br",
            "Connection": "keep-alive",
            "Referer": "https://www.colourlovers.com/",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
          },
        ).timeout(const Duration(seconds: 30));

        client.close();

        if (response.statusCode == 200) {
          final List<dynamic> palettes =
              json.decode(response.body) as List<dynamic>;

          if (palettes.isNotEmpty) {
            final Map<String, dynamic> firstPalette = palettes.first;
            if (firstPalette.containsKey("title")) {
              name = firstPalette["title"];
            }
            if (firstPalette.containsKey("id")) {
              externalId = firstPalette["id"].toString();
            }
          }

          final List<Color> colors = <Color>[];
          for (final Map<String, dynamic> palette in palettes) {
            final List<dynamic> colorList = palette["colors"] as List<dynamic>;
            for (final String colorHex in colorList) {
              // Convert hex color to RGB and add to palette
              final int color = _hexToRgb(colorHex);
              colors.add(Color.rgbaColor(
                ColorUtils.red(color) / 255.0,
                ColorUtils.green(color) / 255.0,
                ColorUtils.blue(color) / 255.0,
              ));
            }
          }

          addColors(colors);
          _log.info(
              "Fetched ${colors.length} colors from COLOURlovers using $baseUrl");
          return; // Success, exit the loop
        } else if (response.statusCode == 403) {
          _log.warning(
              "Access forbidden (403) from $baseUrl - likely blocked by Cloudflare protection");
        } else {
          _log.warning(
              "Failed to fetch colors from $baseUrl: HTTP ${response.statusCode} - ${response.body}");
        }
      } on SocketException catch (e) {
        _log.severe("Network error fetching colors from $baseUrl: $e");
      } on TimeoutException catch (e) {
        _log.severe("Timeout error fetching colors from $baseUrl: $e");
      } catch (e) {
        _log.severe("Error fetching colors from $baseUrl: $e");
      }
    }

    // If we get here, all URLs failed
    _log.severe(
        "All COLOURlovers API endpoints failed (likely blocked by Cloudflare), using local color generation");
    _addFallbackColors();
  }

  /// Add fallback colors when API fails
  void _addFallbackColors() {
    // Try to generate random colors first, then fall back to predefined colors
    try {
      generateRandomColors();
    } catch (e) {
      _log.warning(
          "Failed to generate random colors, using predefined colors: $e");
      addColors([
        Color.rgbaColor(1.0, 0.0, 0.0), // Red
        Color.rgbaColor(0.0, 1.0, 0.0), // Green
        Color.rgbaColor(0.0, 0.0, 1.0), // Blue
        Color.rgbaColor(1.0, 1.0, 0.0), // Yellow
        Color.rgbaColor(1.0, 0.0, 1.0), // Magenta
        Color.rgbaColor(0.0, 1.0, 1.0), // Cyan
        Color.rgbaColor(1.0, 0.5, 0.0), // Orange
        Color.rgbaColor(0.5, 0.0, 1.0), // Purple
        Color.rgbaColor(0.0, 0.5, 0.0), // Dark Green
        Color.rgbaColor(0.5, 0.5, 0.5), // Gray
      ]);
    }
  }

  /// Convert hex color string to RGB integer
  int _hexToRgb(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 3) {
      hex = hex.split("").map((c) => c + c).join();
    }
    final int value = int.parse(hex, radix: 16);
    return ColorUtils.rgb(
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    );
  }
}
