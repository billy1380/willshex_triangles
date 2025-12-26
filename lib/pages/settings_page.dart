import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:willshex_triangles/parts/app_drawer.dart";

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
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _sizeRatioController = TextEditingController();
  final TextEditingController _countRatioController = TextEditingController();
  bool _addTriangleGradients = true;
  bool _annotateWithDimensions = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _widthController.text = (prefs.getInt("image_width") ?? 800).toString();
      _heightController.text = (prefs.getInt("image_height") ?? 600).toString();
      _sizeRatioController.text = (prefs.getInt("size_ratio") ?? 12).toString();
      _addTriangleGradients = prefs.getBool("add_triangle_gradients") ?? true;
      _annotateWithDimensions =
          prefs.getBool("annotate_with_dimensions") ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        "image_width", int.tryParse(_widthController.text) ?? 800);
    await prefs.setInt(
        "image_height", int.tryParse(_heightController.text) ?? 600);
    await prefs.setInt(
        "size_ratio", int.tryParse(_sizeRatioController.text) ?? 12);
    await prefs.setBool("add_triangle_gradients", _addTriangleGradients);
    await prefs.setBool("annotate_with_dimensions", _annotateWithDimensions);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Settings saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: _buildTextField("Width", _widthController,
                      keyboardType: TextInputType.number),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField("Height", _heightController,
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField("Scale Factor", _sizeRatioController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Add triangle gradients"),
              value: _addTriangleGradients,
              onChanged: (bool? value) {
                setState(() {
                  _addTriangleGradients = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: const EdgeInsets.all(0),
              title: const Text("Annotate with dimensions"),
              value: _annotateWithDimensions,
              onChanged: (bool? value) {
                setState(() {
                  _annotateWithDimensions = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Reset logic
                    },
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
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
