import "package:blend_composites/blend_composites.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:image/image.dart" as img;
import "package:logging/logging.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:willshex_triangles/pages/welcome_page.dart";
import "package:willshex_triangles/parts/app_drawer.dart";
import "package:willshex_triangles/parts/palette_history.dart";
import "package:willshex_triangles/parts/palette_picker_dialog.dart";
import "package:willshex_triangles/triangles/graphics/from_source.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/generator_palette_provider.dart";
import "package:willshex_triangles/triangles/graphics/palette_provider/palette_provider.dart";
import "package:willshex_triangles/triangles/triangles.dart";

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
  bool _showImageOverlay = true;

  late int width;
  late int height;
  late int ratioN;
  late int ratioD;
  late bool addGradients;
  late bool annotate;
  late final List<BlendingMode> sortedBlendModes;

  @override
  void initState() {
    super.initState();
    _loadSettingsAndGenerate();
    sortedBlendModes = BlendingMode.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> _loadSettingsAndGenerate() async {
    final prefs = await SharedPreferences.getInstance();
    width = prefs.getInt("image_width") ?? ImageGeneratorConfig.defaultWidth;
    height = prefs.getInt("image_height") ?? ImageGeneratorConfig.defaultHeight;

    Object? ratioObj = prefs.get("size_ratio");
    double ratioVal =
        ImageGeneratorConfig.defaultRatioN / ImageGeneratorConfig.defaultRatioD;
    if (ratioObj is int) {
      ratioVal = ratioObj.toDouble();
    } else if (ratioObj is double) {
      ratioVal = ratioObj;
    }

    ratioN = 10000;
    ratioD = (ratioVal * 10000).toInt();
    if (ratioD == 0) {
      ratioD = 1;
    }

    addGradients = prefs.getBool("add_triangle_gradients") ?? true;
    annotate = prefs.getBool("annotate_with_dimensions") ?? false;

    _generatePalette();
  }

  Future<void> _generatePalette() async {
    try {
      final palette = await widget.paletteProvider();
      if (!mounted) {
        return;
      }

      if (palette != null) {
        setState(() {
          _currentPalette = palette;
          _history.insert(0, _currentPalette!);
        });
        await _generateImage();
      } else {
        if (_history.isEmpty) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go(WelcomePage.routePath);
          }
        }
      }
    } catch (e, stack) {
      _log.severe("Error generating palette", e, stack);
    }
  }

  Future<void> _generateImage() async {
    if (_currentPalette == null) {
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final properties = <String, String>{
        ImageGeneratorConfig.typeKey: _selectedType.name,
        ImageGeneratorConfig.widthKey: width.toString(),
        ImageGeneratorConfig.heightKey: height.toString(),
        ImageGeneratorConfig.ratioNKey: ratioN.toString(),
        ImageGeneratorConfig.ratioDKey: ratioD.toString(),
        ImageGeneratorConfig.addGameGradientsKey: addGradients ? "1" : "0",
        ImageGeneratorConfig.annotateKey: annotate ? "1" : "0",
      };

      if (_selectedImage != null) {
        properties[ImageGeneratorConfig.textureKey] = _selectedImage!.path;
        properties[ImageGeneratorConfig.compositeKey] = _selectedBlendMode.name;
      }

      final storeImage = await ImageGenerator.generateImage(
        properties,
        GeneratorPaletteProvider(() async => _currentPalette),
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

  img.Image? get _paletteSource {
    if (_currentPalette is FromSource) {
      return (_currentPalette as FromSource).source;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _generatedImage != null
          ? FloatingActionButton(
              onPressed: () async {
                await FileSaver.instance.saveFile(
                  name: "triangles",
                  bytes: _generatedImage!,
                  fileExtension: "png",
                  mimeType: MimeType.png,
                );
              },
              tooltip: "Download Image",
              child: const Icon(Icons.download),
            )
          : null,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_paletteSource != null)
            IconButton(
              icon:
                  Icon(_showImageOverlay ? Icons.image : Icons.image_outlined),
              onPressed: () {
                setState(() {
                  _showImageOverlay = !_showImageOverlay;
                });
              },
              tooltip: _showImageOverlay ? "Hide Reference" : "Show Reference",
            ),
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
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      _generatePalette();
                    },
                    icon: const Icon(Icons.add),
                    tooltip: "New Palette",
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _history.clear();
                      });

                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }

                      _generatePalette();
                    },
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: "Clear History",
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: PaletteHistory(
                palettes: _history,
                selectedPalette: _currentPalette,
                onSelected: (palette) {
                  setState(() {
                    _currentPalette = palette;
                    _generateImage();
                  });
                  Navigator.pop(context);
                },
                onEdit: (palette) async {
                  final editedPalette = await showDialog<ws.Palette>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) =>
                        PalettePickerDialog(initialPalette: palette),
                  );

                  if (editedPalette != null && mounted) {
                    setState(() {
                      final index = _history.indexOf(palette);
                      if (index != -1) {
                        _history[index] = editedPalette;
                        if (_currentPalette == palette) {
                          _currentPalette = editedPalette;
                        }
                      }
                    });
                    if (_currentPalette == editedPalette) {
                      _generateImage();
                    }
                  }
                },
                onDelete: _history.length <= 1
                    ? null
                    : (palette) {
                        setState(() {
                          _history.remove(palette);
                          if (_currentPalette == palette) {
                            _currentPalette =
                                _history.isNotEmpty ? _history.last : null;
                          }
                        });
                        if (_currentPalette != null) {
                          _generateImage();
                        }
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
                    items: sortedBlendModes.map((mode) {
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
            child: _isGenerating
                ? const Center(child: CircularProgressIndicator())
                : _generatedImage != null
                    ? Stack(
                        children: [
                          InteractiveViewer(
                            minScale: 0.1,
                            maxScale: 20.0,
                            boundaryMargin:
                                const EdgeInsets.all(double.infinity),
                            panEnabled: true,
                            child: Center(
                              child: Image.memory(
                                _generatedImage!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          if (_showImageOverlay && _paletteSource != null)
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child:
                                    _buildPaletteSourceImage(_paletteSource!),
                              ),
                            ),
                        ],
                      )
                    : const Center(child: Text("Building Triangles...")),
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteSourceImage(dynamic source) {
    if (source is img.Image) {
      return Image.memory(
        Uint8List.fromList(img.encodePng(source)),
        fit: BoxFit.cover,
      );
    }
    return const SizedBox();
  }
}
