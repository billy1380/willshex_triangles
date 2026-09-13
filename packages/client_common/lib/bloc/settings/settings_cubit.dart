import "package:bloc/bloc.dart";
import "package:client_common/bloc/settings/settings_state.dart";
import "package:client_common/models/generator_settings.dart";

abstract class SettingsStorage {
  Future<GeneratorSettings> loadSettings();
  Future<void> saveSettings(GeneratorSettings settings);
}

class InMemorySettingsStorage implements SettingsStorage {
  GeneratorSettings _settings;
  InMemorySettingsStorage([this._settings = const GeneratorSettings()]);

  @override
  Future<GeneratorSettings> loadSettings() async => _settings;

  @override
  Future<void> saveSettings(GeneratorSettings settings) async {
    _settings = settings;
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage _storage;

  SettingsCubit([SettingsStorage? storage])
      : _storage = storage ?? InMemorySettingsStorage(),
        super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final settings = await _storage.loadSettings();
    emit(state.copyWith(settings: settings, isLoaded: true));
  }

  Future<void> updateSettings(GeneratorSettings newSettings) async {
    emit(state.copyWith(settings: newSettings));
    await _storage.saveSettings(newSettings);
  }

  Future<void> updateWidth(int width) async {
    final newSettings = state.settings.copyWith(width: width);
    await updateSettings(newSettings);
  }

  Future<void> updateHeight(int height) async {
    final newSettings = state.settings.copyWith(height: height);
    await updateSettings(newSettings);
  }

  Future<void> updateScaleFactor(double scaleFactor) async {
    const rn = 10000;
    var rd = (scaleFactor * 10000).toInt();
    if (rd == 0) rd = 1;
    final newSettings = state.settings.copyWith(
      scaleFactor: scaleFactor,
      ratioN: rn,
      ratioD: rd,
    );
    await updateSettings(newSettings);
  }

  Future<void> updateAddTriangleGradients(bool value) async {
    final newSettings = state.settings.copyWith(addTriangleGradients: value);
    await updateSettings(newSettings);
  }

  Future<void> updateAnnotateWithDimensions(bool value) async {
    final newSettings = state.settings.copyWith(annotateWithDimensions: value);
    await updateSettings(newSettings);
  }
}
