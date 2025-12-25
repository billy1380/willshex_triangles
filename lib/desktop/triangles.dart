import "dart:io";

import "package:logging/logging.dart";
import "package:willshex/willshex.dart";
import "package:willshex_draw/willshex_draw.dart";

import "../triangles/image_generator.dart";
import "../triangles/store.dart";
import "../triangles/colourlovers/colour_lovers_client_palette.dart";
import "store/file_store.dart";

/// Main desktop application for triangle generation
class Triangles {
  // ignore: unused_field
  static final Logger _log = Logger("Triangles");
  static final Store _store = FileStore();

  /// Main entry point for the desktop application
  static Future<void> main(List<String> args) async {
    String? command;
    String? name;
    String? format;
    int count = 0;
    bool exit = false;
    Map<String, String>? map;

    if (args.isEmpty) {
      stdout.writeln("Enter parameters or exit to exit");
      stdout.writeln(
          "e.g. w=1300&h=400&u=N45DegreeFabric&t=RandomJiggle&rd=69&rn=11&p=RandomColourLovers&a=1");
    } else {
      command = args.first;
    }

    do {
      if (command == null || command.isEmpty) {
        stdout.writeln(">");
        command = stdin.readLineSync();
      }

      if (command == null || command.toLowerCase() == "exit") {
        exit = true;
      } else {
        if (_isSame(command)) {
          if (map == null) {
            continue;
          }
        } else {
          try {
            map = _toMap(command);
          } catch (e) {
            stderr.writeln(e);
            continue;
          }
        }

        try {
          name = "output/genimg_$count";
          count++;

          // Create output directory if it doesn't exist
          final outputDir = Directory("output");
          if (!await outputDir.exists()) {
            await outputDir.create(recursive: true);
          }

          format = await ImageGenerator.generate(
            map,
            _newPalette,
            File(name).openWrite(),
            _store,
          );

          await File(name).rename("$name.$format");
          stdout.writeln("Generated image: $name.$format");
        } catch (e) {
          stderr.writeln("Error generating image: $e");
        }
      }

      if (args.isNotEmpty) {
        exit = true;
      }
    } while (!exit);

    stdout.writeln("Bye!");
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

  /// Create a new palette from COLOURlovers
  static Future<Palette> _newPalette() async {
    final palette = ColourLoversClientPalette();
    await palette.getColors("random", 0, 1);
    return palette;
  }
}

/// Command-line interface for the triangles application
Future<void> main(List<String> args) async {
  setupLogging();

  await Triangles.main([
    "w=1300&h=400&u=N45DegreeFabric&t=RandomJiggle&rd=69&rn=11&p=RandomColourLovers&a=1"
  ]);
}
