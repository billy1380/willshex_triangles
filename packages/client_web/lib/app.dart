import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:jaspr_router/jaspr_router.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_web/routes.dart";
import "package:triangles_web/services/local_storage_settings_storage.dart";
import "package:triangles_web/services/local_storage_theme_storage.dart";
import "package:triangles_web/services/web_theme_applier.dart";
import "package:triangles_web/ui/bloc_provider.dart";

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SettingsCubit _settingsCubit;
  late final ThemeCubit _themeCubit;
  late final WebThemeApplier _themeApplier;

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(LocalStorageSettingsStorage());
    _themeCubit = ThemeCubit(LocalStorageThemeStorage());
    _themeApplier = WebThemeApplier(_themeCubit);
  }

  @override
  void dispose() {
    _themeApplier.dispose();
    _themeCubit.close();
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
      bloc: _themeCubit,
      child: BlocProvider<SettingsCubit>(
        bloc: _settingsCubit,
        child: div([
          Component.element(
              tag: "style", children: [Component.text(AppTheme.cssVars)]),
          Router(
            routes: Routes.routes,
          ),
        ]),
      ),
    );
  }
}
