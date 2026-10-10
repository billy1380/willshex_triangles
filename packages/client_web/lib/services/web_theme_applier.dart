import "dart:async";
import "dart:js_interop";

import "package:triangles_common/client_common.dart";
import "package:web/web.dart" as web;

/// Applies the [ThemeCubit] state to the document as `data-bs-theme`.
///
/// When the mode is [AppThemeMode.system] the browser's
/// `prefers-color-scheme` media query is used (and tracked live). If the
/// browser cannot report a preference, light is used.
class WebThemeApplier {
  static const String _darkQuery = "(prefers-color-scheme: dark)";

  final ThemeCubit _cubit;
  StreamSubscription<AppThemeMode>? _subscription;
  web.MediaQueryList? _mediaQuery;
  JSFunction? _mediaListener;

  WebThemeApplier(this._cubit) {
    try {
      _mediaQuery = web.window.matchMedia(_darkQuery);
      _mediaListener = ((web.Event _) => apply()).toJS;
      _mediaQuery!.addEventListener("change", _mediaListener);
    } catch (_) {
      _mediaQuery = null;
    }
    _subscription = _cubit.stream.listen((_) => apply());
    apply();
  }

  /// The browser's dark preference, or `null` when it cannot be detected.
  bool? get systemIsDark {
    final query = _mediaQuery;
    // A media list of "not all" means the query is unsupported.
    if (query == null || query.media == "not all") return null;
    return query.matches;
  }

  bool get isDark => _cubit.state.resolveIsDark(systemIsDark);

  void apply() {
    web.document.documentElement
        ?.setAttribute("data-bs-theme", isDark ? "dark" : "light");
  }

  void dispose() {
    _subscription?.cancel();
    if (_mediaListener != null) {
      _mediaQuery?.removeEventListener("change", _mediaListener);
    }
  }
}
