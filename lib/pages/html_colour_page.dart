import "package:blend_composites/blend_composites.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:logging/logging.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:willshex_triangles/parts/app_drawer.dart";
import "package:willshex_triangles/parts/palette_history_widget.dart";
import "package:willshex_triangles/triangles/graphics/named_color_palette.dart";
import "package:willshex_triangles/triangles/triangles.dart";

class HtmlColourPage extends StatefulWidget {
  static const String routePath = "/htmlcolour";

  static Widget builder(BuildContext context, GoRouterState state) {
    return const HtmlColourPage._();
  }

  const HtmlColourPage._();

  @override
  State<HtmlColourPage> createState() => _HtmlColourPageState();
}

class _HtmlColourPageState extends State<HtmlColourPage> {
  static final Logger _log = Logger("HtmlColourPage");

  // Options
  TrianglesType _selectedType = TrianglesType.ribbons;
  TilableImage? _selectedImage;
  BlendingMode _selectedBlendMode = BlendingMode.colorBurn;

  // State
  ws.Palette? _currentPalette;
  final List<ws.Palette> _history = [];
  Uint8List? _generatedImage;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _generateRandomPalette();
  }

  void _generateRandomPalette() {
    setState(() {
      _currentPalette = NamedColorPalette();
      _history.insert(0, _currentPalette!);
      _generateImage();
    });
  }

  Future<void> _generateImage() async {
    if (_currentPalette == null) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      // Serialize palette to hex strings
      final List<String> hexColors = _currentPalette!.colors.map((c) {
        final int r = (c.red * 255).toInt();
        final int g = (c.green * 255).toInt();
        final int b = (c.blue * 255).toInt();
        return "${r.toRadixString(16).padLeft(2, '0')}"
            "${g.toRadixString(16).padLeft(2, '0')}"
            "${b.toRadixString(16).padLeft(2, '0')}";
      }).toList();

      final properties = <String, String>{
        ImageGeneratorConfig.typeKey: _selectedType.name,
        ImageGeneratorConfig.widthKey: "800",
        ImageGeneratorConfig.heightKey: "600",
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
        title: const Text("HTML Colour"),
      ),
      body: Row(
        children: [
          // Main Content (Canvas + Controls)
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Toolbar
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  child: Row(
                    children: [
                      // Triangle Type Dropdown
                      Expanded(
                        child: DropdownButtonFormField<TrianglesType>(
                          initialValue: _selectedType,
                          decoration: const InputDecoration(
                            labelText: "Type",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                      // Background Image Dropdown
                      Expanded(
                        child: DropdownButtonFormField<TilableImage?>(
                          isExpanded: true,
                          initialValue: _selectedImage,
                          decoration: const InputDecoration(
                            labelText: "Texture",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                      // Blend Mode Dropdown (Disabled if no image)
                      Expanded(
                        child: DropdownButtonFormField<BlendingMode>(
                          initialValue: _selectedBlendMode,
                          decoration: const InputDecoration(
                            labelText: "Blend Mode",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                      const SizedBox(width: 16),
                      // Generate Button
                      FilledButton.icon(
                        onPressed: _generateRandomPalette,
                        icon: const Icon(Icons.refresh),
                        label: const Text("New Palette"),
                      ),
                    ],
                  ),
                ),

                // Canvas Area
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
          ),

          // History Sidebar
          Container(
            width: 300,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.grey[300]!)),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "History",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: PaletteHistoryWidget(
                    palettes: _history,
                    onSelected: (palette) {
                      setState(() {
                        _currentPalette = palette;
                        _generateImage();
                      });
                    },
                    onDelete: (palette) {
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
        ],
      ),
    );
  }
}
