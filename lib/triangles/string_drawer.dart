import "dart:typed_data";

import "package:fs_shim/fs_shim.dart";
import "package:image/image.dart" as img;
import "package:logging/logging.dart";

/// Drawer for rendering text using bitmap fonts
/// This is a basic implementation following typical Java patterns
class StringDrawer {
  static final Logger _log = Logger("StringDrawer");

  final String _fontName;
  final int _fontSize;

  final Map<String, Map<String, dynamic>> _chars =
      <String, Map<String, dynamic>>{};
  final Map<String, dynamic> _details = <String, dynamic>{};

  img.Image? _texture;

  /// Constructor with font name and size
  StringDrawer(this._fontName, this._fontSize);

  /// Load font data
  Future<void> load({
    Future<Uint8List?> Function(String path)? assetLoader,
    FileSystem? fs,
  }) async {
    try {
      final String basePath = "assets/fonts/$_fontName/$_fontSize";
      String? fntContent;
      Uint8List? pngBytes;

      // Try loading from assets first
      if (assetLoader != null) {
        final Uint8List? fntBytes = await assetLoader("$basePath.fnt");
        if (fntBytes != null) {
          fntContent = String.fromCharCodes(fntBytes);
        }
        pngBytes = await assetLoader("$basePath.png");
      }

      // Fallback to filesystem if filesystem provided and assets failed
      if ((fntContent == null || pngBytes == null) && fs != null) {
        final File fntFile = fs.file("$basePath.fnt");
        final File pngFile = fs.file("$basePath.png");

        if (await fntFile.exists() && await pngFile.exists()) {
          fntContent = await fntFile.readAsString();
          pngBytes = await pngFile.readAsBytes();
        }
      }

      if (fntContent != null && pngBytes != null) {
        _texture = img.decodePng(pngBytes);
        _parseBMFont(fntContent);
        _log.info("Font loaded: $_fontName size $_fontSize");
      } else {
        _log.warning(
            "Font files not found: $basePath. Using fallback basic data.");
        _createBasicCharacterData();
      }
    } catch (e) {
      _log.warning("Error loading font: $e");
      _createBasicCharacterData();
    }
  }

  void _parseBMFont(String content) {
    _chars.clear();
    final lines = content.split("\n");
    for (var line in lines) {
      line = line.trim();
      if (line.startsWith("common")) {
        final Map<String, String> params = _parseParams(line);
        if (params.containsKey("lineHeight")) {
          _details["lineHeight"] = int.parse(params["lineHeight"]!);
        }

        if (params.containsKey("base")) {
          _details["base"] = int.parse(params["base"]!);
        }

        if (params.containsKey("scaleW")) {
          _details["scaleW"] = int.parse(params["scaleW"]!);
        }

        if (params.containsKey("scaleH")) {
          _details["scaleH"] = int.parse(params["scaleH"]!);
        }
      } else if (line.startsWith("char") && !line.startsWith("chars")) {
        final Map<String, String> params = _parseParams(line);
        final int id = int.parse(params["id"] ?? "0");

        _chars[id.toString()] = <String, dynamic>{
          "x": int.parse(params["x"] ?? "0"),
          "y": int.parse(params["y"] ?? "0"),
          "width": int.parse(params["width"] ?? "0"),
          "height": int.parse(params["height"] ?? "0"),
          "xoffset": int.parse(params["xoffset"] ?? "0"),
          "yoffset": int.parse(params["yoffset"] ?? "0"),
          "xadvance": int.parse(params["xadvance"] ?? "0"),
          "page": int.parse(params["page"] ?? "0"),
          "chnl": int.parse(params["chnl"] ?? "15"),
        };
      }
    }
  }

  Map<String, String> _parseParams(String line) {
    final Map<String, String> params = {};
    final RegExp exp = RegExp(r'(\w+)=(".*?"|\S+)');
    final matches = exp.allMatches(line);
    for (var m in matches) {
      String key = m.group(1)!;
      String value = m.group(2)!;
      if (value.startsWith('"')) value = value.substring(1, value.length - 1);
      params[key] = value;
    }
    return params;
  }

  /// Create basic character data for common characters
  void _createBasicCharacterData() {
    // Create basic character data for ASCII characters 32-126
    for (int i = 32; i <= 126; i++) {
      final String charCode = i.toString();

      _chars[charCode] = <String, dynamic>{
        "x": (i - 32) * 8,
        "y": 0,
        "width": 8,
        "height": 8,
        "xoffset": 0,
        "yoffset": 0,
        "xadvance": 8,
        "page": 0,
        "chnl": 15,
      };
    }

    _details["lineHeight"] = 8;
    _details["base"] = 8;
    _details["scaleW"] = 256;
    _details["scaleH"] = 256;
    _details["pages"] = 1;
  }

  /// Get character data for a specific character
  Map<String, dynamic> getCharacter(String character) {
    if (character.isEmpty) return <String, dynamic>{};
    final String charCode = character.codeUnitAt(0).toString();
    return _chars[charCode] ?? <String, dynamic>{};
  }

  /// Get character data by character code
  Map<String, dynamic> getCharacterByCode(int charCode) {
    return _chars[charCode.toString()] ?? <String, dynamic>{};
  }

  /// Get Y offset for a character
  int getYOffset(String character) {
    final charData = getCharacter(character);
    return charData["yoffset"] ?? 0;
  }

  /// Get X offset for a character
  int getXOffset(String character) {
    final charData = getCharacter(character);
    return charData["xoffset"] ?? 0;
  }

  /// Get width of a character (the texture width, not advance)
  int getCharacterWidth(String character) {
    final charData = getCharacter(character);
    return charData["width"] ?? 0;
  }

  /// Get height of a character
  int getHeight(String character) {
    final charData = getCharacter(character);
    return charData["height"] ?? 0;
  }

  /// Get character advance width
  int getCharacterAdvance(String character) {
    final charData = getCharacter(character);
    return charData["xadvance"] ?? 0;
  }

  /// Get width of a string
  int getWidth(String s) {
    int width = 0;
    for (int c = 0; c < s.length; c++) {
      final character = s[c];
      width += getCharacterAdvance(character);
    }
    return width;
  }

  /// Get kerning between two characters
  int getKerning(String first, String second) {
    return 0;
  }

  /// Draw a string at the specified position
  void draw(img.Image dst, String s, int ox, int oy) {
    if (_texture == null) return;

    int offset = 0;

    for (int c = 0; c < s.length; c++) {
      final character = s[c];
      final charData = getCharacter(character);

      final int yOffset = charData["yoffset"] ?? 0;
      final int xOffset = charData["xoffset"] ?? 0;
      final int width = charData["width"] ?? 0;
      final int height = charData["height"] ?? 0;
      final int x = charData["x"] ?? 0;
      final int y = charData["y"] ?? 0;

      img.compositeImage(dst, _texture!,
          srcX: x,
          srcY: y,
          srcW: width,
          srcH: height,
          dstX: ox + offset + xOffset,
          dstY: oy + yOffset);

      offset += getCharacterAdvance(character);
    }
  }

  /// Get the font file name
  String? get fontFile {
    return _details["file"]?.toString().replaceAll('"', "");
  }

  /// Get the line height
  int get lineHeight => _details["lineHeight"] ?? 0;

  /// Get the base line
  int get baseLine => _details["base"] ?? 0;

  /// Get the texture width
  int get textureWidth => _details["scaleW"] ?? 0;

  /// Get the texture height
  int get textureHeight => _details["scaleH"] ?? 0;

  /// Get the texture image data (raw bytes not strictly needed with package:image object, but adhering to API)
  Uint8List? get imageData => _texture?.getBytes();

  /// Get all character data
  Map<String, Map<String, dynamic>> get characters => Map.unmodifiable(_chars);

  /// Get font details
  Map<String, dynamic> get details => Map.unmodifiable(_details);

  @override
  String toString() {
    return "StringDrawer(fontName: $_fontName, fontSize: $_fontSize)";
  }
}
