import "package:jaspr/jaspr.dart";
import "package:logging/logging.dart";
import "package:client_web/app.dart";

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print("[${record.level.name}] ${record.loggerName}: ${record.message}");
  });

  runApp(const App());
}
