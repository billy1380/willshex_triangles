import 'colour_lovers_client_palette.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('[[34m[1m[4m[0m${record.level.name}] ${record.time}: ${record.loggerName}: ${record.message}');
  });

  final palette = ColourLoversClientPalette();
  final success = await palette.testConnection();
  print('ColourLoversClientPalette testConnection: ${success ? 'SUCCESS' : 'FAILURE'}');
} 