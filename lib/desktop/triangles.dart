import "dart:async";
import "dart:io" as io;

import "package:fs_shim/fs_io.dart";
import "package:logging/logging.dart";
import "package:willshex/willshex.dart";
import "package:willshex_draw/willshex_draw.dart";
import "package:willshex_triangles/extensions/string_ex.dart";
import "package:willshex_triangles/triangles/triangles.dart";

import "../triangles/graphics/palette_provider/generator_palette_provider.dart";

/// Main desktop application for triangle generation
class Triangles {
  // ignore: unused_field
  static final Logger _log = Logger("Triangles");
  static final Store _store = FileStore();

  /// Main entry point for the desktop application
  static Future<void> main(List<String> args) async {
    final FileSystem fs = fileSystemIo;
    String? command;
    String? name;
    String? format;
    int count = 0;
    bool exitLoop = false;
    Map<String, String>? map;

    if (args.isEmpty) {
      _log.info("Enter parameters or exit to exit");
      _log.info(
          "e.g. w=1300&h=400&u=N45DegreeFabric&t=RandomJiggle&rd=69&rn=11&p=RandomColour&a=1");
    } else {
      command = args.first;
    }

    do {
      if (command == null || command.isEmpty) {
        // We still need dart:io for stdin in CLI
        command = io.stdin.readLineSync();
      }

      if (command == null || command.toLowerCase() == "exit") {
        exitLoop = true;
      } else {
        if (_isSame(command)) {
          if (map == null) {
            continue;
          }
        } else {
          try {
            map = _toMap(command);
          } catch (e, stack) {
            _log.severe("Error parsing command", e, stack);
            continue;
          }
        }

        try {
          name = "output/genimg_$count";
          count++;

          // Create output directory if it doesn't exist
          final Directory outputDir = fs.directory("output");
          if (!await outputDir.exists()) {
            await outputDir.create(recursive: true);
          }

          final File validFile = fs.file(name);
          final StreamSink<List<int>> sink = validFile.openWrite();

          format = await ImageGenerator.generate(
            map,
            map[ImageGeneratorConfig.paletteKey].fromConfiguration(
              map,
              supplier: GeneratorPaletteProvider(_newPalette),
            ),
            sink,
            _store,
            fs: fs,
          );

          await sink.close();

          await validFile.rename("$name.$format");
          _log.info("Generated image: $name.$format");
        } catch (e, stack) {
          _log.severe("Error generating image", e, stack);
        }
      }

      if (args.isNotEmpty) {
        exitLoop = true;
      }
    } while (!exitLoop);

    _log.info("Bye!");
  }

  /// Check if command is empty (same as previous)
  static bool _isSame(String command) {
    return command.isEmpty;
  }

  /// Convert command string to map
  static Map<String, String> _toMap(String command) {
    final Map<String, String> result = <String, String>{};
    final List<String> pairs = command.split("&");

    for (final String pair in pairs) {
      final List<String> keyValue = pair.split("=");
      if (keyValue.length == 2) {
        result[keyValue[0]] = keyValue[1];
      }
    }

    return result;
  }

  /// Create a new random palette
  static Future<Palette> _newPalette() async {
    final palette = RandomColorPalette();
    palette.generateRandomColors();
    return palette;
  }
}

/// Command-line interface for the triangles application
Future<void> main(List<String> args) async {
  setupLogging();

  await Triangles.main([
    "w=1300&h=400&u=N45DegreeFabric&t=RandomJiggle&rd=69&rn=11&p=Random&a=1"
  ]);
}
