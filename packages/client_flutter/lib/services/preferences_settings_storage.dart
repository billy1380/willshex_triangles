import "package:shared_preferences/shared_preferences.dart";
import "package:client_common/client_common.dart";

class PreferencesSettingsStorage implements SettingsStorage {
  @override
  Future<GeneratorSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final width =
        prefs.getInt("image_width") ?? ImageGeneratorConfig.defaultWidth;
    final height =
        prefs.getInt("image_height") ?? ImageGeneratorConfig.defaultHeight;

    Object? ratioObj = prefs.get("size_ratio");
    double ratioVal =
        ImageGeneratorConfig.defaultRatioN / ImageGeneratorConfig.defaultRatioD;
    if (ratioObj is int) {
      ratioVal = ratioObj.toDouble();
    } else if (ratioObj is double) {
      ratioVal = ratioObj;
    }

    final addGradients = prefs.getBool("add_triangle_gradients") ?? true;
    final annotate = prefs.getBool("annotate_with_dimensions") ?? false;

    return GeneratorSettings.fromValues(
      width: width,
      height: height,
      scaleFactor: ratioVal,
      addTriangleGradients: addGradients,
      annotateWithDimensions: annotate,
    );
  }

  @override
  Future<void> saveSettings(GeneratorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("image_width", settings.width);
    await prefs.setInt("image_height", settings.height);
    await prefs.setDouble("size_ratio", settings.scaleFactor);
    await prefs.setBool(
        "add_triangle_gradients", settings.addTriangleGradients);
    await prefs.setBool(
        "annotate_with_dimensions", settings.annotateWithDimensions);
  }
}
