import "package:shared_preferences/shared_preferences.dart";
import "package:triangles_common/client_common.dart";

/// Persists the [AppThemeMode] in [SharedPreferences].
class PreferencesThemeStorage implements ThemeStorage {
  final SharedPreferences? _prefs;

  PreferencesThemeStorage([this._prefs]);

  @override
  AppThemeMode load() =>
      AppThemeMode.fromName(_prefs?.getString(AppThemeMode.storageKey));

  @override
  Future<void> save(AppThemeMode mode) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(AppThemeMode.storageKey, mode.name);
  }
}
