import "package:blend_composites/blend_composites.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image/image.dart" as img;
import "package:shared_preferences/shared_preferences.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";
import "package:client_flutter/parts/palette_history.dart";
import "package:client_flutter/parts/palette_picker_dialog.dart";

class TriangleGeneratorPage extends StatefulWidget {
  final String title;
  final PaletteProvider paletteProvider;
  final Future<ws.Palette?> Function(BuildContext context)? customPalettePicker;

  const TriangleGeneratorPage({
    super.key,
    required this.title,
    required this.paletteProvider,
    this.customPalettePicker,
  });

  @override
  State<TriangleGeneratorPage> createState() => _TriangleGeneratorPageState();
}

class _TriangleGeneratorPageState extends State<TriangleGeneratorPage> {
  late final TriangleGeneratorCubit _cubit;
  bool _isPickerOpen = false;

  @override
  void initState() {
    super.initState();
    _cubit = TriangleGeneratorCubit(
      title: widget.title,
      paletteProvider: widget.customPalettePicker != null
          ? GeneratorPaletteProvider(() async {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _openCustomPalettePicker();
              });
              return null;
            })
          : widget.paletteProvider,
      assetLoader: (path) async {
        return (await rootBundle.load(path)).buffer.asUint8List();
      },
    );
    _loadSettings();
  }

  Future<void> _openCustomPalettePicker() async {
    if (!mounted || widget.customPalettePicker == null || _isPickerOpen) return;
    _isPickerOpen = true;
    try {
      final palette = await widget.customPalettePicker!(context);
      if (palette != null && mounted) {
        _cubit.selectPalette(palette);
      }
    } finally {
      _isPickerOpen = false;
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final width =
        prefs.getInt("image_width") ?? ImageGeneratorConfig.defaultWidth;
    final height =
        prefs.getInt("image_height") ?? ImageGeneratorConfig.defaultHeight;

    Object? ratioObj = prefs.get("size_ratio");
    double ratioVal =
        ImageGeneratorConfig.defaultRatioN / ImageGeneratorConfig.defaultRatioD;
    if (ratioObj is int) {
      ratioVal = ratioObj.toDouble();
    } else if (ratioObj is double) {
      ratioVal = ratioObj;
    }

    final addGradients = prefs.getBool("add_triangle_gradients") ?? true;
    final annotate = prefs.getBool("annotate_with_dimensions") ?? false;

    final settings = GeneratorSettings.fromValues(
      width: width,
      height: height,
      scaleFactor: ratioVal,
      addTriangleGradients: addGradients,
      annotateWithDimensions: annotate,
    );

    _cubit.updateSettings(settings);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TriangleGeneratorCubit, TriangleGeneratorState>(
      bloc: _cubit,
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: state.generatedImage != null
              ? FloatingActionButton(
                  onPressed: () async {
                    await FileSaver.instance.saveFile(
                      name: "triangles",
                      bytes: state.generatedImage!,
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
              if (state.paletteSource != null)
                IconButton(
                  icon: Icon(state.showImageOverlay
                      ? Icons.image
                      : Icons.image_outlined),
                  onPressed: _cubit.toggleImageOverlay,
                  tooltip: state.showImageOverlay
                      ? "Hide Reference"
                      : "Show Reference",
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
                          _cubit.generatePalette();
                        },
                        icon: const Icon(Icons.add),
                        tooltip: "New Palette",
                      ),
                      IconButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          _cubit.clearHistory();
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
                    palettes: state.history,
                    selectedPalette: state.currentPalette,
                    onSelected: (palette) {
                      _cubit.selectPalette(palette);
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
                        _cubit.updatePalette(palette, editedPalette);
                      }
                    },
                    onDelete: state.history.length <= 1
                        ? null
                        : (palette) => _cubit.deletePalette(palette),
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
                        initialValue: state.selectedType,
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
                            _cubit.selectType(value);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<TilableImage?>(
                        isExpanded: true,
                        initialValue: state.selectedImage,
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
                          ...TilableImage.values.map((imgItem) {
                            return DropdownMenuItem(
                              value: imgItem,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.asset(
                                      imgItem.path,
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      imgItem.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) => _cubit.selectTexture(value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<BlendingMode>(
                        initialValue: state.selectedBlendMode,
                        decoration: const InputDecoration(
                          labelText: "Blend Mode",
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        items: state.sortedBlendModes.map((mode) {
                          return DropdownMenuItem(
                            value: mode,
                            child: Text(mode.name),
                          );
                        }).toList(),
                        onChanged: state.selectedImage == null
                            ? null
                            : (value) {
                                if (value != null) {
                                  _cubit.selectBlendMode(value);
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.isGenerating
                    ? const Center(child: CircularProgressIndicator())
                    : state.generatedImage != null
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
                                    state.generatedImage!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              if (state.showImageOverlay &&
                                  state.paletteSource != null)
                                Positioned(
                                  bottom: 20,
                                  right: 20,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: _buildPaletteSourceImage(
                                        state.paletteSource!),
                                  ),
                                ),
                            ],
                          )
                        : Center(
                            child: widget.customPalettePicker != null &&
                                    state.currentPalette == null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        state.errorMessage ??
                                            "No palette selected",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton.icon(
                                        onPressed: _openCustomPalettePicker,
                                        icon: const Icon(Icons.colorize),
                                        label: const Text("Create Palette"),
                                      ),
                                    ],
                                  )
                                : Text(state.errorMessage ??
                                    "Building Triangles..."),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaletteSourceImage(img.Image source) {
    return Image.memory(
      Uint8List.fromList(img.encodePng(source)),
      fit: BoxFit.cover,
    );
  }
}
