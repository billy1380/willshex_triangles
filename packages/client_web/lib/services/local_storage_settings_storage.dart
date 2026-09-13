import "package:client_common/client_common.dart";
import "package:web/web.dart" as web;

class LocalStorageSettingsStorage implements SettingsStorage {
  @override
  GeneratorSettings? loadSettingsSync() {
    try {
      final storage = web.window.localStorage;
      final widthStr = storage.getItem(GeneratorSettings.keyWidth);
      final heightStr = storage.getItem(GeneratorSettings.keyHeight);
      final ratioStr = storage.getItem(GeneratorSettings.keyScaleFactor);
      final gradientsStr =
          storage.getItem(GeneratorSettings.keyAddTriangleGradients);
      final annotateStr =
          storage.getItem(GeneratorSettings.keyAnnotateWithDimensions);

      final width = int.tryParse(widthStr ?? "");
      final height = int.tryParse(heightStr ?? "");
      final ratio = double.tryParse(ratioStr ?? "");
      final gradients = gradientsStr != null ? gradientsStr == "true" : null;
      final annotate = annotateStr != null ? annotateStr == "true" : null;

      return GeneratorSettings.fromValues(
        width: width,
        height: height,
        scaleFactor: ratio,
        addTriangleGradients: gradients,
        annotateWithDimensions: annotate,
      );
    } catch (_) {
      return const GeneratorSettings();
    }
  }

  @override
  Future<GeneratorSettings> loadSettings() async {
    return loadSettingsSync() ?? const GeneratorSettings();
  }

  @override
  Future<void> saveSettings(GeneratorSettings settings) async {
    try {
      final storage = web.window.localStorage;
      storage.setItem(GeneratorSettings.keyWidth, settings.width.toString());
      storage.setItem(GeneratorSettings.keyHeight, settings.height.toString());
      storage.setItem(
          GeneratorSettings.keyScaleFactor, settings.scaleFactor.toString());
      storage.setItem(GeneratorSettings.keyAddTriangleGradients,
          settings.addTriangleGradients.toString());
      storage.setItem(GeneratorSettings.keyAnnotateWithDimensions,
          settings.annotateWithDimensions.toString());
    } catch (_) {}
  }
}
