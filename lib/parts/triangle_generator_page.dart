import "package:blend_composites/blend_composites.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:logging/logging.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:willshex_triangles/parts/app_drawer.dart";
import "package:willshex_triangles/parts/palette_history_widget.dart";
import "package:willshex_triangles/triangles/triangles.dart";

typedef PaletteProvider = Future<ws.Palette> Function();

class TriangleGeneratorPage extends StatefulWidget {
  final String title;
  final PaletteProvider paletteProvider;

  const TriangleGeneratorPage({
    super.key,
    required this.title,
    required this.paletteProvider,
  });

  @override
  State<TriangleGeneratorPage> createState() => _TriangleGeneratorPageState();
}

class _TriangleGeneratorPageState extends State<TriangleGeneratorPage> {
  static final Logger _log = Logger("TriangleGeneratorPage");

  TrianglesType _selectedType = TrianglesType.ribbons;
  TilableImage? _selectedImage;
  BlendingMode _selectedBlendMode = BlendingMode.colorBurn;

  ws.Palette? _currentPalette;
  final List<ws.Palette> _history = [];
  Uint8List? _generatedImage;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _generateRandomPalette();
  }

  Future<void> _generateRandomPalette() async {
    try {
      final palette = await widget.paletteProvider();
      setState(() {
        _currentPalette = palette;
        _history.insert(0, _currentPalette!);
      });
      await _generateImage();
    } catch (e, stack) {
      _log.severe("Error generating palette", e, stack);
    }
  }

  Future<void> _generateImage() async {
    if (_currentPalette == null) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final List<String> hexColors = _currentPalette!.colors.map((c) {
        final int r = (c.red * 255).toInt();
        final int g = (c.green * 255).toInt();
        final int b = (c.blue * 255).toInt();
        return "${r.toRadixString(16).padLeft(2, '0')}"
            "${g.toRadixString(16).padLeft(2, '0')}"
            "${b.toRadixString(16).padLeft(2, '0')}";
      }).toList();

      final prefs = await SharedPreferences.getInstance();
      final width = prefs.getInt("image_width") ?? 800;
      final height = prefs.getInt("image_height") ?? 600;
      final addGradients = prefs.getBool("add_triangle_gradients") ?? true;
      final annotate = prefs.getBool("annotate_with_dimensions") ?? false;

      final properties = <String, String>{
        ImageGeneratorConfig.typeKey: _selectedType.name,
        ImageGeneratorConfig.widthKey: width.toString(),
        ImageGeneratorConfig.heightKey: height.toString(),
        ImageGeneratorConfig.addGameGradientsKey: addGradients ? "1" : "0",
        ImageGeneratorConfig.annotateKey: annotate ? "1" : "0",
        ImageGeneratorConfig.paletteKey: PaletteType.commaSeparatedList.name,
        ImageGeneratorConfig.paletteColoursKey: hexColors.join(","),
      };

      if (_selectedImage != null) {
        properties[ImageGeneratorConfig.textureKey] = _selectedImage!.path;
        properties[ImageGeneratorConfig.compositeKey] = _selectedBlendMode.name;
      }

      final storeImage = await ImageGenerator.generateImage(
        properties,
        () async => _currentPalette!,
        null,
        assetLoader: (path) async {
          return (await rootBundle.load(path)).buffer.asUint8List();
        },
      );

      if (mounted && storeImage?.content != null) {
        setState(() {
          _generatedImage = Uint8List.fromList(storeImage!.content!);
        });
      }
    } catch (e, stack) {
      _log.severe("Error generating image", e, stack);
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: "Show History",
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "History",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _generateRandomPalette();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add),
                    tooltip: "New Palette",
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _history.clear();
                      });
                      _generateRandomPalette();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: "Clear History",
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: PaletteHistoryWidget(
                palettes: _history,
                selectedPalette: _currentPalette,
                onSelected: (palette) {
                  setState(() {
                    _currentPalette = palette;
                    _generateImage();
                  });
                  Navigator.pop(context);
                },
                onDelete: _history.length <= 1
                    ? null
                    : (palette) {
                        setState(() {
                          _history.remove(palette);
                          if (_currentPalette == palette) {
                            _currentPalette = null;
                          }
                        });
                      },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TrianglesType>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: "Type",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    items: TrianglesType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toString().split(".").last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                        _generateImage();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<TilableImage?>(
                    isExpanded: true,
                    initialValue: _selectedImage,
                    decoration: const InputDecoration(
                      labelText: "Texture",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text("None"),
                      ),
                      ...TilableImage.values.map((img) {
                        return DropdownMenuItem(
                          value: img,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.asset(
                                  img.path,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  img.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedImage = value);
                      _generateImage();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<BlendingMode>(
                    initialValue: _selectedBlendMode,
                    decoration: const InputDecoration(
                      labelText: "Blend Mode",
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    items: BlendingMode.values.map((mode) {
                      return DropdownMenuItem(
                        value: mode,
                        child: Text(mode.name),
                      );
                    }).toList(),
                    onChanged: _selectedImage == null
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _selectedBlendMode = value);
                              _generateImage();
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _isGenerating
                  ? const CircularProgressIndicator()
                  : Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: _generatedImage != null
                          ? Image.memory(
                              _generatedImage!,
                              fit: BoxFit.contain,
                            )
                          : const SizedBox(
                              width: 400,
                              height: 300,
                              child: Center(
                                child: Text(
                                  "Click 'New Palette' to generate",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
