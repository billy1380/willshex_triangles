import "package:willshex_embedding/willshex_embedding.dart";
import "package:triangles_flutter/services/preferences_settings_storage.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_flutter/parts/app_drawer.dart";

/// Pure embeddable view for Settings, decoupled from Scaffold, AppBar, and AppDrawer.
/// Shared settings provider for Flutter.
class TrianglesFlutterSettings {
  TrianglesFlutterSettings._();
  static SettingsCubit? _cubit;
  static SettingsCubit get cubit =>
      _cubit ??= SettingsCubit(PreferencesSettingsStorage());

  static void useStorage(SettingsStore storage) {
    _cubit = SettingsCubit(EmbeddingSettingsAdapter(storage));
  }
}

class SettingsView extends StatefulWidget {
  final SettingsCubit? settingsCubit;
  final ThemeCubit? themeCubit;

  const SettingsView({
    this.settingsCubit,
    this.themeCubit,
    super.key,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late final SettingsCubit _cubit;
  ThemeCubit? _themeCubit;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _sizeRatioController = TextEditingController();

  SettingsCubit _resolveSettingsCubit() {
    if (widget.settingsCubit != null) return widget.settingsCubit!;
    try {
      return BlocProvider.of<SettingsCubit>(context, listen: false);
    } catch (_) {
      return TrianglesFlutterSettings.cubit;
    }
  }

  ThemeCubit? _resolveThemeCubit() {
    if (widget.themeCubit != null) return widget.themeCubit!;
    try {
      return BlocProvider.of<ThemeCubit>(context, listen: false);
    } catch (_) {
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = _resolveSettingsCubit();
    _themeCubit = _resolveThemeCubit();
    _syncControllers(_cubit.state.settings);
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _sizeRatioController.dispose();
    // Settings cubit is shared, do not close
    super.dispose();
  }

  void _syncControllers(GeneratorSettings settings) {
    if (_widthController.text != settings.width.toString()) {
      _widthController.text = settings.width.toString();
    }
    if (_heightController.text != settings.height.toString()) {
      _heightController.text = settings.height.toString();
    }
    if (_sizeRatioController.text != settings.scaleFactor.toString()) {
      _sizeRatioController.text = settings.scaleFactor.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      bloc: _cubit,
      listener: (context, state) {
        _syncControllers(state.settings);
      },
      builder: (context, state) {
        if (state.isLoaded) {
          _syncControllers(state.settings);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      AppStrings.imageWidth,
                      _widthController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null) _cubit.updateWidth(parsed);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      AppStrings.imageHeight,
                      _heightController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        final parsed = int.tryParse(val);
                        if (parsed != null) _cubit.updateHeight(parsed);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                AppStrings.scaleFactor,
                _sizeRatioController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  if (parsed != null) _cubit.updateScaleFactor(parsed);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(AppStrings.addTriangleGradients),
                value: state.settings.addTriangleGradients,
                onChanged: (bool value) {
                  _cubit.updateAddTriangleGradients(value);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: const EdgeInsets.all(0),
                title: const Text(AppStrings.annotateWithDimensions),
                value: state.settings.annotateWithDimensions,
                onChanged: (bool value) {
                  _cubit.updateAnnotateWithDimensions(value);
                },
              ),
              if (_themeCubit != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _ThemeDropdown(cubit: _themeCubit!),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          onChanged: onChanged,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            label: Text(label),
          ),
        ),
      ],
    );
  }
}

/// Full page wrapper for SettingsPage.
class SettingsPage extends StatelessWidget {
  static const String routePath = "/settings";

  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;
  final SettingsCubit? settingsCubit;
  final ThemeCubit? themeCubit;

  SettingsPage({
    this.showDrawer = true,
    this.showAppBar = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    this.settingsCubit,
    this.themeCubit,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  static Widget builder(BuildContext context, GoRouterState state) {
    return SettingsPage();
  }

  @override
  Widget build(BuildContext context) {
    final body = Material(
        color: Colors.transparent,
        child: SettingsView(
          settingsCubit: settingsCubit,
          themeCubit: themeCubit,
        ));
    if (!showAppBar && !showDrawer) {
      return body;
    }

    return Scaffold(
      drawer: showDrawer ? AppDrawer(paths: paths) : null,
      appBar: showAppBar
          ? AppBar(
              title: const Text(AppStrings.navSettings),
            )
          : null,
      body: body,
    );
  }
}

class _ThemeDropdown extends StatelessWidget {
  final ThemeCubit cubit;

  const _ThemeDropdown({required this.cubit});

  static IconData _icon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => Icons.brightness_auto,
        AppThemeMode.light => Icons.light_mode,
        AppThemeMode.dark => Icons.dark_mode,
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      bloc: cubit,
      builder: (context, current) => DropdownButtonFormField<AppThemeMode>(
        key: ValueKey(current),
        initialValue: current,
        decoration: const InputDecoration(
          label: Text(AppStrings.theme),
        ),
        items: [
          for (final mode in AppThemeMode.values)
            DropdownMenuItem<AppThemeMode>(
              value: mode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_icon(mode), size: 18),
                  const SizedBox(width: 8),
                  Text(mode.label),
                ],
              ),
            ),
        ],
        onChanged: (mode) {
          if (mode != null) cubit.setMode(mode);
        },
      ),
    );
  }
}
