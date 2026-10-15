import "package:bloc/bloc.dart";
import "package:triangles_common/models/app_theme_mode.dart";

/// Persists the [AppThemeMode] preference.
abstract class ThemeStorage {
  AppThemeMode load();
  Future<void> save(AppThemeMode mode);
}

class InMemoryThemeStorage implements ThemeStorage {
  AppThemeMode _mode;
  InMemoryThemeStorage([this._mode = AppThemeMode.defaultMode]);

  @override
  AppThemeMode load() => _mode;

  @override
  Future<void> save(AppThemeMode mode) async {
    _mode = mode;
  }
}

/// Holds the selected [AppThemeMode] for both clients.
class ThemeCubit extends Cubit<AppThemeMode> {
  final ThemeStorage _storage;

  ThemeCubit([ThemeStorage? storage])
      : this._(storage ?? InMemoryThemeStorage());

  ThemeCubit._(this._storage) : super(_storage.load());

  Future<void> setMode(AppThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await _storage.save(mode);
  }

  /// Toggles to the next [AppThemeMode] given the current [isPlatformDark] platform brightness.
  Future<void> toggle([bool isPlatformDark = false]) async {
    await setMode(state.next(isPlatformDark));
  }
}
