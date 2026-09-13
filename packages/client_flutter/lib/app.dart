import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:google_fonts/google_fonts.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/routes.dart";
import "package:client_flutter/services/preferences_settings_storage.dart";

import "package:shared_preferences/shared_preferences.dart";

class App extends StatefulWidget {
  final SharedPreferences? prefs;
  const App({this.prefs, super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SettingsCubit _settingsCubit;

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(PreferencesSettingsStorage(widget.prefs));
  }

  @override
  void dispose() {
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>.value(
      value: _settingsCubit,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          textTheme: GoogleFonts.outfitTextTheme(),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
