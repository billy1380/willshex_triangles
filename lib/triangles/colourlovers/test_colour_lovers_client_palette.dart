import "colour_lovers_client_palette.dart";
import "package:logging/logging.dart";

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // print("[${record.level.name}] ${record.time}: ${record.loggerName}: ${record.message}");
  });

  final Logger log = Logger("TestColourLoversClientPalette");
  final palette = ColourLoversClientPalette();
  final success = await palette.testConnection();
  log.info(
      "ColourLoversClientPalette testConnection: ${success ? "SUCCESS" : "FAILURE"}");
}
