import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";

/// Pure embeddable view for Settings, decoupled from Scaffold, AppBar, and AppDrawer.
class SettingsView extends StatefulWidget {
  final SettingsCubit? settingsCubit;

  const SettingsView({this.settingsCubit, super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsCubit? _localSettingsCubit;
  late final SettingsCubit _cubit;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _sizeRatioController = TextEditingController();

  SettingsCubit _resolveSettingsCubit() {
    if (widget.settingsCubit != null) return widget.settingsCubit!;
    try {
      return BlocProvider.of<SettingsCubit>(context, listen: false);
    } catch (_) {
      _localSettingsCubit ??= SettingsCubit();
      return _localSettingsCubit!;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit = _resolveSettingsCubit();
    _syncControllers(_cubit.state.settings);
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _sizeRatioController.dispose();
    _localSettingsCubit?.close();
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

  SettingsPage({
    this.showDrawer = true,
    this.showAppBar = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    this.settingsCubit,
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
    final body = SettingsView(settingsCubit: settingsCubit);
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
