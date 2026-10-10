import "package:triangles_common/bloc/settings/settings_cubit.dart";
import "package:triangles_common/models/generator_settings.dart";
import "package:willshex_embedding/willshex_embedding.dart";

/// Adapts an [SettingsStore] from the embedding host into a [SettingsStorage] for Triangles.
class EmbeddingSettingsAdapter implements SettingsStorage {
  final SettingsStore _storage;

  EmbeddingSettingsAdapter(this._storage);

  @override
  GeneratorSettings? loadSettingsSync() {
    final width = _storage.getIntSync(GeneratorSettings.keyWidth);
    final height = _storage.getIntSync(GeneratorSettings.keyHeight);
    final ratio = _storage.getDoubleSync(GeneratorSettings.keyScaleFactor);
    final gradients =
        _storage.getBoolSync(GeneratorSettings.keyAddTriangleGradients);
    final annotate =
        _storage.getBoolSync(GeneratorSettings.keyAnnotateWithDimensions);

    if (width == null &&
        height == null &&
        ratio == null &&
        gradients == null &&
        annotate == null) {
      return null;
    }

    return GeneratorSettings.fromValues(
      width: width,
      height: height,
      scaleFactor: ratio,
      addTriangleGradients: gradients,
      annotateWithDimensions: annotate,
    );
  }

  @override
  Future<GeneratorSettings> loadSettings() async {
    final syncSettings = loadSettingsSync();
    if (syncSettings != null) return syncSettings;

    final width = await _storage.getInt(GeneratorSettings.keyWidth);
    final height = await _storage.getInt(GeneratorSettings.keyHeight);
    final ratio = await _storage.getDouble(GeneratorSettings.keyScaleFactor);
    final gradients =
        await _storage.getBool(GeneratorSettings.keyAddTriangleGradients);
    final annotate =
        await _storage.getBool(GeneratorSettings.keyAnnotateWithDimensions);

    return GeneratorSettings.fromValues(
      width: width,
      height: height,
      scaleFactor: ratio,
      addTriangleGradients: gradients,
      annotateWithDimensions: annotate,
    );
  }

  @override
  Future<void> saveSettings(GeneratorSettings settings) async {
    await _storage.setInt(GeneratorSettings.keyWidth, settings.width);
    await _storage.setInt(GeneratorSettings.keyHeight, settings.height);
    await _storage.setDouble(
        GeneratorSettings.keyScaleFactor, settings.scaleFactor);
    await _storage.setBool(GeneratorSettings.keyAddTriangleGradients,
        settings.addTriangleGradients);
    await _storage.setBool(GeneratorSettings.keyAnnotateWithDimensions,
        settings.annotateWithDimensions);
  }
}
