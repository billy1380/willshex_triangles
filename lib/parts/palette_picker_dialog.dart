import "package:flutter/material.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;

class PalettePickerDialog extends StatefulWidget {
  const PalettePickerDialog({super.key});

  @override
  State<PalettePickerDialog> createState() => _PalettePickerDialogState();
}

class _PalettePickerDialogState extends State<PalettePickerDialog> {
  final TextEditingController _nameController =
      TextEditingController(text: "My Custom Palette");
  final List<Color> _colors = [Colors.red, Colors.green, Colors.blue];
  int _selectedIndex = 0;

  void _addColor() {
    setState(() {
      Color nextColor;
      if (_colors.isEmpty) {
        nextColor = Colors.red;
      } else {
        // Simple related color: shift hue by ~30 degrees
        final HSLColor lastHsl = HSLColor.fromColor(_colors.last);
        nextColor = lastHsl.withHue((lastHsl.hue + 30) % 360).toColor();
      }
      _colors.add(nextColor);
      _selectedIndex = _colors.length - 1;
    });
  }

  void _usePalette() {
    final palette = ws.Palette(_nameController.text);
    palette.addColors(
        _colors.map((c) => ws.Color.rgbaColor(c.r, c.g, c.b, c.a)).toList());

    Navigator.of(context).pop(palette);
  }

  void _updateSelectedColor(Color newColor) {
    setState(() {
      if (_selectedIndex >= 0 && _selectedIndex < _colors.length) {
        _colors[_selectedIndex] = newColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color? currentColor;
    if (_selectedIndex >= 0 && _selectedIndex < _colors.length) {
      currentColor = _colors[_selectedIndex];
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text("Create Custom Palette",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Palette Name"),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 60,
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
                      final isSelected = index == _selectedIndex;

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3)
                                : Border.all(color: Colors.black12),
                          ),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _colors.removeAt(index);
                                  if (_selectedIndex >= _colors.length) {
                                    _selectedIndex = _colors.length - 1;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(height: 32),
              if (currentColor != null) ...[
                Row(
                  children: [
                    Container(height: 40, width: 40, color: currentColor),
                    const SizedBox(width: 16),
                    Text("Edit Color",
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                Slider(
                  value: currentColor.r * 255,
                  min: 0,
                  max: 255,
                  label: "R",
                  activeColor: Colors.red,
                  onChanged: (v) =>
                      _updateSelectedColor(currentColor!.withRed(v.toInt())),
                ),
                Slider(
                  value: currentColor.g * 255,
                  min: 0,
                  max: 255,
                  label: "G",
                  activeColor: Colors.green,
                  onChanged: (v) =>
                      _updateSelectedColor(currentColor!.withGreen(v.toInt())),
                ),
                Slider(
                  value: currentColor.b * 255,
                  min: 0,
                  max: 255,
                  label: "B",
                  activeColor: Colors.blue,
                  onChanged: (v) =>
                      _updateSelectedColor(currentColor!.withBlue(v.toInt())),
                ),
              ] else
                const SizedBox(
                    height: 150,
                    child: Center(child: Text("Select a color to edit"))),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _colors.isEmpty ? null : _usePalette,
                    child: const Text("Select"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
