import "package:jaspr/jaspr.dart";
import "package:jaspr_router/jaspr_router.dart";
import "package:client_common/client_common.dart";
import "package:client_web/routes.dart";
import "package:client_web/services/local_storage_settings_storage.dart";
import "package:client_web/ui/bloc_provider.dart";

class App extends StatefulComponent {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final SettingsCubit _settingsCubit;

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(LocalStorageSettingsStorage());
  }

  @override
  void dispose() {
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      bloc: _settingsCubit,
      child: Router(
        routes: Routes.routes,
      ),
    );
  }
}
