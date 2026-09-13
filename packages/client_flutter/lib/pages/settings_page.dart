import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";
import "package:client_flutter/services/preferences_settings_storage.dart";

class SettingsPage extends StatefulWidget {
  static const String routePath = "/settings";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const SettingsPage._();
  }

  const SettingsPage._();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsCubit _cubit;
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _sizeRatioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = SettingsCubit(PreferencesSettingsStorage());
  }

  @override
  void dispose() {
    _cubit.close();
    _widthController.dispose();
    _heightController.dispose();
    _sizeRatioController.dispose();
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

        return Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            title: const Text("Settings"),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "Width",
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
                        "Height",
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
                  "Scale Factor",
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
                  title: const Text("Add triangle gradients"),
                  value: state.settings.addTriangleGradients,
                  onChanged: (bool value) {
                    _cubit.updateAddTriangleGradients(value);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: const Text("Annotate with dimensions"),
                  value: state.settings.annotateWithDimensions,
                  onChanged: (bool value) {
                    _cubit.updateAnnotateWithDimensions(value);
                  },
                ),
              ],
            ),
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
