import "package:shared_preferences/shared_preferences.dart";
import "package:client_common/client_common.dart";

class PreferencesSettingsStorage implements SettingsStorage {
  final SharedPreferences? _prefs;

  PreferencesSettingsStorage([this._prefs]);

  GeneratorSettings _fromPrefs(SharedPreferences prefs) {
    final width = prefs.getInt(GeneratorSettings.keyWidth);
    final height = prefs.getInt(GeneratorSettings.keyHeight);

    Object? ratioObj = prefs.get(GeneratorSettings.keyScaleFactor);
    double? ratioVal;
    if (ratioObj is int) {
      ratioVal = ratioObj.toDouble();
    } else if (ratioObj is double) {
      ratioVal = ratioObj;
    }

    final addGradients =
        prefs.getBool(GeneratorSettings.keyAddTriangleGradients);
    final annotate = prefs.getBool(GeneratorSettings.keyAnnotateWithDimensions);

    return GeneratorSettings.fromValues(
      width: width,
      height: height,
      scaleFactor: ratioVal,
      addTriangleGradients: addGradients,
      annotateWithDimensions: annotate,
    );
  }

  @override
  GeneratorSettings? loadSettingsSync() {
    if (_prefs != null) {
      return _fromPrefs(_prefs);
    }
    return null;
  }

  @override
  Future<GeneratorSettings> loadSettings() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return _fromPrefs(prefs);
  }

  @override
  Future<void> saveSettings(GeneratorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(GeneratorSettings.keyWidth, settings.width);
    await prefs.setInt(GeneratorSettings.keyHeight, settings.height);
    await prefs.setDouble(GeneratorSettings.keyScaleFactor, settings.scaleFactor);
    await prefs.setBool(
        GeneratorSettings.keyAddTriangleGradients, settings.addTriangleGradients);
    await prefs.setBool(
        GeneratorSettings.keyAnnotateWithDimensions, settings.annotateWithDimensions);
  }
}
