import "package:triangles_common/client_common.dart";
import "package:web/web.dart" as web;

/// Persists the [AppThemeMode] in the browser's localStorage.
class LocalStorageThemeStorage implements ThemeStorage {
  @override
  AppThemeMode load() {
    try {
      return AppThemeMode.fromName(
          web.window.localStorage.getItem(AppThemeMode.storageKey));
    } catch (_) {
      return AppThemeMode.defaultMode;
    }
  }

  @override
  Future<void> save(AppThemeMode mode) async {
    try {
      web.window.localStorage.setItem(AppThemeMode.storageKey, mode.name);
    } catch (_) {}
  }
}
