import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_flutter/routes.dart";
import "package:triangles_flutter/services/preferences_settings_storage.dart";
import "package:triangles_flutter/services/preferences_theme_storage.dart";
import "package:triangles_flutter/theme/app_theme_data.dart";

import "package:shared_preferences/shared_preferences.dart";

class App extends StatefulWidget {
  final SharedPreferences? prefs;
  const App({this.prefs, super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SettingsCubit _settingsCubit;
  late final ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(PreferencesSettingsStorage(widget.prefs));
    _themeCubit = ThemeCubit(PreferencesThemeStorage(widget.prefs));
  }

  @override
  void dispose() {
    _themeCubit.close();
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: _settingsCubit),
        BlocProvider<ThemeCubit>.value(value: _themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, mode) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppThemeData.light,
          darkTheme: AppThemeData.dark,
          themeMode: AppThemeData.toThemeMode(mode),
          routerConfig: router,
        ),
      ),
    );
  }
}
