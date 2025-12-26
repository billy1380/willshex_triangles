import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:willshex_draw/willshex_draw.dart' as ws;
import 'package:willshex_triangles/parts/triangle_generator_page.dart';
import 'package:willshex_triangles/parts/app_drawer.dart';

class PalettePickerPage extends StatefulWidget {
  static const String routePath = "/palettepicker";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const PalettePickerPage();
  }

  const PalettePickerPage({super.key});

  @override
  State<PalettePickerPage> createState() => _PalettePickerPageState();
}

class _PalettePickerPageState extends State<PalettePickerPage> {
  final TextEditingController _nameController =
      TextEditingController(text: "My Custom Palette");
  final List<Color> _colors = [Colors.red, Colors.green, Colors.blue];

  void _addColor() async {
    Color pickerColor = Colors.blue;
    final Color? newColor = await showDialog<Color>(
        context: context,
        builder: (context) {
          Color tempColor = pickerColor;
          return AlertDialog(
            title: const Text('Pick a color'),
            content: SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    Container(height: 50, width: 50, color: tempColor),
                    Slider(
                      value: tempColor.red.toDouble(),
                      min: 0,
                      max: 255,
                      label: "R",
                      activeColor: Colors.red,
                      onChanged: (v) => setState(
                          () => tempColor = tempColor.withRed(v.toInt())),
                    ),
                    Slider(
                      value: tempColor.green.toDouble(),
                      min: 0,
                      max: 255,
                      label: "G",
                      activeColor: Colors.green,
                      onChanged: (v) => setState(
                          () => tempColor = tempColor.withGreen(v.toInt())),
                    ),
                    Slider(
                      value: tempColor.blue.toDouble(),
                      min: 0,
                      max: 255,
                      label: "B",
                      activeColor: Colors.blue,
                      onChanged: (v) => setState(
                          () => tempColor = tempColor.withBlue(v.toInt())),
                    ),
                  ],
                );
              }),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  Navigator.of(context).pop(tempColor);
                },
              ),
            ],
          );
        });

    if (newColor != null) {
      setState(() {
        _colors.add(newColor);
      });
    }
  }

  void _usePalette() {
    final palette = ws.Palette(_nameController.text);
    palette.addColors(_colors
        .map((c) => ws.Color.rgbaColor(
            c.red / 255.0, c.green / 255.0, c.blue / 255.0, c.opacity))
        .toList());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TriangleGeneratorPage(
          title: palette.name ?? "Custom",
          paletteProvider: (_, __) async => palette,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Palette Picker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Palette Name"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _colors.length + 1,
                itemBuilder: (context, index) {
                  if (index == _colors.length) {
                    return InkWell(
                      onTap: _addColor,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    );
                  }
                  final color = _colors[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close,
                            size: 16, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _colors.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _colors.isEmpty ? null : _usePalette,
                child: const Text("Use Palette"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
