import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
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
  final TextEditingController _sizeRatioController = TextEditingController();
  final TextEditingController _countRatioController = TextEditingController();
  final TextEditingController _historyItemCountController =
      TextEditingController();
  bool _addTriangleGradients = true;

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
            _buildTextField("Size Ratio", _sizeRatioController),
            const SizedBox(height: 16),
            _buildTextField("Count Ratio", _countRatioController),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text("Add triangle gradients"),
              value: _addTriangleGradients,
              onChanged: (bool? value) {
                setState(() {
                  _addTriangleGradients = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildTextField("Shown palette items", _historyItemCountController),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Reset logic
                    },
                    child: const Text("Reset"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Save logic
                    },
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
