import "package:client_common/client_common.dart";
import "package:web/web.dart" as web;

class LocalStorageSettingsStorage implements SettingsStorage {
  @override
  Future<GeneratorSettings> loadSettings() async {
    try {
      final storage = web.window.localStorage;
      final widthStr = storage.getItem("image_width");
      final heightStr = storage.getItem("image_height");
      final ratioStr = storage.getItem("size_ratio");
      final gradientsStr = storage.getItem("add_triangle_gradients");
      final annotateStr = storage.getItem("annotate_with_dimensions");

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
  Future<void> saveSettings(GeneratorSettings settings) async {
    try {
      final storage = web.window.localStorage;
      storage.setItem("image_width", settings.width.toString());
      storage.setItem("image_height", settings.height.toString());
      storage.setItem("size_ratio", settings.scaleFactor.toString());
      storage.setItem(
          "add_triangle_gradients", settings.addTriangleGradients.toString());
      storage.setItem("annotate_with_dimensions",
          settings.annotateWithDimensions.toString());
    } catch (_) {}
  }
}
