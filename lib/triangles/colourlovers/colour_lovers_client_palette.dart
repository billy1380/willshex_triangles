import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:willshex_draw/willshex_draw.dart';
import '../graphics/color_utils.dart';

/// Client for fetching color palettes from COLOURlovers API
class ColourLoversClientPalette extends Palette {
  static final Logger _log = Logger('ColourLoversClientPalette');
  
  /// Base URLs for the COLOURlovers API (try HTTPS first, then HTTP)
  static const List<String> _baseUrls = [
    'https://www.colourlovers.com/api',
    'http://www.colourlovers.com/api',
  ];
  
  /// Constructor for the COLOURlovers client palette
  ColourLoversClientPalette() : super('COLOURlovers Palette');

  /// Test network connectivity to COLOURlovers API
  Future<bool> testConnection() async {
    for (final String baseUrl in _baseUrls) {
      try {
        final http.Client client = http.Client();
        final response = await client.get(
          Uri.parse('$baseUrl/palettes/random?format=json&numResults=1&resultOffset=0'),
          headers: {
            'User-Agent': 'WillshexTriangles/1.0',
            'Accept': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));
        
        client.close();
        
        if (response.statusCode == 200) {
          _log.info('Network connection test successful with $baseUrl');
          return true;
        } else {
          _log.warning('Network connection test failed with $baseUrl: HTTP ${response.statusCode}');
        }
      } catch (e) {
        _log.severe('Network connection test failed with $baseUrl: $e');
      }
    }
    return false;
  }

  /// Fetch colors from COLOURlovers API
  /// 
  /// [type] - The type of palette to fetch (e.g., 'random', 'top', 'new')
  /// [numResults] - Number of results to fetch
  /// [resultOffset] - Offset for pagination
  Future<void> getColors(String type, int resultOffset, int numResults) async {
    for (final String baseUrl in _baseUrls) {
      try {
        final String url = '$baseUrl/palettes/$type?format=json&numResults=$numResults&resultOffset=$resultOffset';
        
        _log.info('Fetching colors from: $url');
        
        // Create HTTP client with timeout and proper headers
        final http.Client client = http.Client();
        
        final http.Response response = await client.get(
          Uri.parse(url),
          headers: {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'application/json, text/plain, */*',
            'Accept-Language': 'en-US,en;q=0.9',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Referer': 'https://www.colourlovers.com/',
            'Sec-Fetch-Dest': 'empty',
            'Sec-Fetch-Mode': 'cors',
            'Sec-Fetch-Site': 'same-origin',
          },
        ).timeout(const Duration(seconds: 30));
        
        client.close();
        
        if (response.statusCode == 200) {
          final List<dynamic> palettes = json.decode(response.body) as List<dynamic>;
          
          final List<Color> colors = <Color>[];
          for (final Map<String, dynamic> palette in palettes) {
            final List<dynamic> colorList = palette['colors'] as List<dynamic>;
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
          _log.info('Fetched ${colors.length} colors from COLOURlovers using $baseUrl');
          return; // Success, exit the loop
        } else if (response.statusCode == 403) {
          _log.warning('Access forbidden (403) from $baseUrl - likely blocked by Cloudflare protection');
        } else {
          _log.warning('Failed to fetch colors from $baseUrl: HTTP ${response.statusCode} - ${response.body}');
        }
      } on SocketException catch (e) {
        _log.severe('Network error fetching colors from $baseUrl: $e');
      } on TimeoutException catch (e) {
        _log.severe('Timeout error fetching colors from $baseUrl: $e');
      } catch (e) {
        _log.severe('Error fetching colors from $baseUrl: $e');
      }
    }
    
    // If we get here, all URLs failed
    _log.severe('All COLOURlovers API endpoints failed (likely blocked by Cloudflare), using local color generation');
    _addFallbackColors();
  }

  /// Generate random colors locally as fallback
  void _generateRandomColors() {
    final List<Color> colors = <Color>[];
    final Random random = Random();
    
    // Generate different types of color palettes
    final int paletteType = random.nextInt(4);
    
    switch (paletteType) {
      case 0: // Warm colors
        _generateWarmPalette(colors, random);
        break;
      case 1: // Cool colors
        _generateCoolPalette(colors, random);
        break;
      case 2: // Complementary colors
        _generateComplementaryPalette(colors, random);
        break;
      case 3: // Analogous colors
        _generateAnalogousPalette(colors, random);
        break;
    }
    
    addColors(colors);
    _log.info('Generated ${colors.length} random colors locally (palette type: $paletteType)');
  }

  /// Generate warm color palette (reds, oranges, yellows)
  void _generateWarmPalette(List<Color> colors, Random random) {
    for (int i = 0; i < 8; i++) {
      final double r = 0.5 + random.nextDouble() * 0.5; // 0.5-1.0
      final double g = random.nextDouble() * 0.6; // 0.0-0.6
      final double b = random.nextDouble() * 0.3; // 0.0-0.3
      colors.add(Color.rgbaColor(r, g, b));
    }
  }

  /// Generate cool color palette (blues, greens, purples)
  void _generateCoolPalette(List<Color> colors, Random random) {
    for (int i = 0; i < 8; i++) {
      final double r = random.nextDouble() * 0.4; // 0.0-0.4
      final double g = random.nextDouble() * 0.7; // 0.0-0.7
      final double b = 0.4 + random.nextDouble() * 0.6; // 0.4-1.0
      colors.add(Color.rgbaColor(r, g, b));
    }
  }

  /// Generate complementary color palette
  void _generateComplementaryPalette(List<Color> colors, Random random) {
    final double baseHue = random.nextDouble();
    
    for (int i = 0; i < 6; i++) {
      final double hue = (baseHue + i * 0.1667) % 1.0; // 60-degree intervals
      final double saturation = 0.6 + random.nextDouble() * 0.4; // 0.6-1.0
      final double value = 0.7 + random.nextDouble() * 0.3; // 0.7-1.0
      
      final List<double> rgb = _hsvToRgb(hue, saturation, value);
      colors.add(Color.rgbaColor(rgb[0], rgb[1], rgb[2]));
    }
  }

  /// Generate analogous color palette
  void _generateAnalogousPalette(List<Color> colors, Random random) {
    final double baseHue = random.nextDouble();
    
    for (int i = 0; i < 8; i++) {
      final double hue = (baseHue + i * 0.125) % 1.0; // 45-degree intervals
      final double saturation = 0.5 + random.nextDouble() * 0.5; // 0.5-1.0
      final double value = 0.6 + random.nextDouble() * 0.4; // 0.6-1.0
      
      final List<double> rgb = _hsvToRgb(hue, saturation, value);
      colors.add(Color.rgbaColor(rgb[0], rgb[1], rgb[2]));
    }
  }

  /// Convert HSV to RGB
  List<double> _hsvToRgb(double h, double s, double v) {
    final int i = (h * 6).floor();
    final double f = h * 6 - i;
    final double p = v * (1 - s);
    final double q = v * (1 - f * s);
    final double t = v * (1 - (1 - f) * s);

    switch (i % 6) {
      case 0: return [v, t, p];
      case 1: return [q, v, p];
      case 2: return [p, v, t];
      case 3: return [p, q, v];
      case 4: return [t, p, v];
      case 5: return [v, p, q];
      default: return [v, t, p];
    }
  }

  /// Add fallback colors when API fails
  void _addFallbackColors() {
    // Try to generate random colors first, then fall back to predefined colors
    try {
      _generateRandomColors();
    } catch (e) {
      _log.warning('Failed to generate random colors, using predefined colors: $e');
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
    hex = hex.replaceAll('#', '');
    if (hex.length == 3) {
      hex = hex.split('').map((c) => c + c).join();
    }
    final int value = int.parse(hex, radix: 16);
    return ColorUtils.rgb(
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    );
  }
} 