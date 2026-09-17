import "dart:async";

import "package:blend_composites/blend_composites.dart";
import "package:file_saver/file_saver.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image/image.dart" as img;
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_flutter/parts/app_drawer.dart";
import "package:client_flutter/parts/palette_history.dart";
import "package:client_flutter/parts/palette_picker_dialog.dart";

/// Pure embeddable view for triangle generation.
/// Decoupled from Scaffold, AppBar, and Drawer.
class TriangleGeneratorView extends StatefulWidget {
  final String title;
  final PaletteProvider? paletteProvider;
  final GeneratorType? generatorType;
  final Future<ws.Palette?> Function(BuildContext context)? customPalettePicker;
  final SettingsCubit? settingsCubit;
  final bool showDownloadFab;
  final bool showHistoryInControls;
  final bool showOverlayInControls;

  const TriangleGeneratorView({
    super.key,
    required this.title,
    this.paletteProvider,
    this.generatorType,
    this.customPalettePicker,
    this.settingsCubit,
    this.showDownloadFab = true,
    this.showHistoryInControls = false,
    this.showOverlayInControls = false,
  });

  @override
  State<TriangleGeneratorView> createState() => TriangleGeneratorViewState();
}

class TriangleGeneratorViewState extends State<TriangleGeneratorView> {
  late final TriangleGeneratorCubit _cubit;
  late final TransformationController _transformationController;
  double _currentScale = 1.0;
  SettingsCubit? _localSettingsCubit;
  StreamSubscription<SettingsState>? _settingsSub;
  bool _isPickerOpen = false;

  TriangleGeneratorCubit get cubit => _cubit;
  TransformationController get transformationController =>
      _transformationController;

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
  void initState() {
    super.initState();
    final settingsCubit = _resolveSettingsCubit();
    final settings = settingsCubit.state.settings;

    final provider = widget.generatorType != null
        ? widget.generatorType!.createProvider(
            settings: settings,
            getSettings: () => _resolveSettingsCubit().state.settings,
            pickerCallback: widget.customPalettePicker != null
                ? () async {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      openCustomPalettePicker();
                    });
                    return null;
                  }
                : null,
          )
        : (widget.customPalettePicker != null
            ? GeneratorPaletteProvider(() async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  openCustomPalettePicker();
                });
                return null;
              })
            : widget.paletteProvider!);

    _cubit = TriangleGeneratorCubit(
      title: widget.title,
      settings: settings,
      paletteProvider: provider,
      assetLoader: (path) async {
        return (await rootBundle.load(path)).buffer.asUint8List();
      },
    );

    _transformationController = TransformationController();
    _transformationController.addListener(_onTransformationChanged);

    _settingsSub = settingsCubit.stream.listen((settingsState) {
      if (mounted) {
        _cubit.updateSettings(settingsState.settings);
      }
    });
  }

  void _onTransformationChanged() {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if ((scale - _currentScale).abs() > 0.001) {
      setState(() {
        _currentScale = scale;
      });
    }
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _zoomBy(double factor, Size viewportSize) {
    final currentMatrix = _transformationController.value;
    final currentScale = currentMatrix.getMaxScaleOnAxis();
    final newScale = (currentScale * factor).clamp(0.1, 20.0);
    if ((newScale - currentScale).abs() < 0.001) return;
    final actualFactor = newScale / currentScale;

    final cx = viewportSize.width / 2;
    final cy = viewportSize.height / 2;

    final matrix = Matrix4.translationValues(cx, cy, 0.0)
      ..multiply(Matrix4.diagonal3Values(actualFactor, actualFactor, 1.0))
      ..multiply(Matrix4.translationValues(-cx, -cy, 0.0))
      ..multiply(currentMatrix);

    _transformationController.value = matrix;
  }

  Future<void> openCustomPalettePicker() async {
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

  void openHistorySheet(BuildContext context, TriangleGeneratorState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SizedBox(
        height: MediaQuery.of(sheetContext).size.height * 0.7,
        child: buildHistoryPanel(
          context: sheetContext,
          state: state,
          onClose: () => Navigator.pop(sheetContext),
        ),
      ),
    );
  }

  Widget buildHistoryPanel({
    required BuildContext context,
    required TriangleGeneratorState state,
    required VoidCallback onClose,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 8.0, 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.history,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () {
                  onClose();
                  _cubit.generatePalette();
                },
                icon: const Icon(Icons.add),
                tooltip: AppStrings.newPalette,
              ),
              IconButton(
                onPressed: () {
                  onClose();
                  _cubit.clearHistory();
                },
                icon: const Icon(Icons.delete_sweep),
                tooltip: AppStrings.clearHistory,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: PaletteHistory(
            palettes: state.history,
            selectedPalette: state.currentPalette,
            onSelected: (palette) {
              _cubit.selectPalette(palette);
              onClose();
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
    );
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    _settingsSub?.cancel();
    _cubit.close();
    _localSettingsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TriangleGeneratorCubit, TriangleGeneratorState>(
      bloc: _cubit,
      builder: (context, state) {
        return Stack(
          children: [
            Column(
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
                            labelText: AppStrings.type,
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
                            labelText: AppStrings.texture,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text(AppStrings.textureNone),
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
                            labelText: AppStrings.blendMode,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
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
                      if (widget.showOverlayInControls &&
                          state.paletteSource != null)
                        IconButton(
                          icon: Icon(state.showImageOverlay
                              ? Icons.image
                              : Icons.image_outlined),
                          onPressed: _cubit.toggleImageOverlay,
                          tooltip: state.showImageOverlay
                              ? AppStrings.hideReference
                              : AppStrings.showReference,
                        ),
                      if (widget.showHistoryInControls)
                        IconButton(
                          icon: const Icon(Icons.history),
                          onPressed: () => openHistorySheet(context, state),
                          tooltip: AppStrings.showHistory,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.isGenerating
                      ? const Center(child: CircularProgressIndicator())
                      : state.generatedImage != null
                          ? LayoutBuilder(
                              builder: (context, constraints) {
                                final viewportSize = constraints.biggest;
                                return Stack(
                                  children: [
                                    InteractiveViewer(
                                      transformationController:
                                          _transformationController,
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
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                                width: 2),
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
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Material(
                                        color: Theme.of(context).cardColor,
                                        elevation: 3,
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .dividerColor
                                                  .withAlpha(50),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    size: 18),
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                                padding: EdgeInsets.zero,
                                                tooltip: "Zoom out (-20%)",
                                                onPressed: () => _zoomBy(
                                                    0.8, viewportSize),
                                              ),
                                              InkWell(
                                                onTap: _resetZoom,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 4),
                                                  child: Text(
                                                    "${(_currentScale * 100).round()}%",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    size: 18),
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                                padding: EdgeInsets.zero,
                                                tooltip: "Zoom in (+25%)",
                                                onPressed: () => _zoomBy(
                                                    1.25, viewportSize),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.restart_alt,
                                                    size: 18),
                                                constraints:
                                                    const BoxConstraints(
                                                        minWidth: 32,
                                                        minHeight: 32),
                                                padding: EdgeInsets.zero,
                                                tooltip: "Reset zoom and pan",
                                                onPressed: _resetZoom,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Center(
                              child: widget.customPalettePicker != null &&
                                      state.currentPalette == null
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          state.errorMessage ??
                                              AppStrings.noPaletteSelected,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton.icon(
                                          onPressed: openCustomPalettePicker,
                                          icon: const Icon(Icons.colorize),
                                          label: const Text(
                                              AppStrings.createPalette),
                                        ),
                                      ],
                                    )
                                  : Text(state.errorMessage ??
                                      AppStrings.buildingTriangles),
                            ),
                ),
              ],
            ),
            if (widget.showDownloadFab && state.generatedImage != null)
              Positioned(
                left: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: () async {
                    await FileSaver.instance.saveFile(
                      name: "triangles",
                      bytes: state.generatedImage!,
                      fileExtension: "png",
                      mimeType: MimeType.png,
                    );
                  },
                  tooltip: AppStrings.downloadImage,
                  child: const Icon(Icons.download),
                ),
              ),
          ],
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

/// Full page wrapper for TriangleGenerator.
/// Supports standalone use or embedding with configurable drawer and app bar.
class TriangleGeneratorPage extends StatefulWidget {
  final String title;
  final PaletteProvider? paletteProvider;
  final GeneratorType? generatorType;
  final Future<ws.Palette?> Function(BuildContext context)? customPalettePicker;
  final bool showDrawer;
  final bool showAppBar;
  final TrianglesRoutePaths paths;
  final SettingsCubit? settingsCubit;

  TriangleGeneratorPage({
    super.key,
    required this.title,
    this.paletteProvider,
    this.generatorType,
    this.customPalettePicker,
    this.showDrawer = true,
    this.showAppBar = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    this.settingsCubit,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  State<TriangleGeneratorPage> createState() => _TriangleGeneratorPageState();
}

class _TriangleGeneratorPageState extends State<TriangleGeneratorPage> {
  final GlobalKey<TriangleGeneratorViewState> _viewKey =
      GlobalKey<TriangleGeneratorViewState>();

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar && !widget.showDrawer) {
      return TriangleGeneratorView(
        key: _viewKey,
        title: widget.title,
        paletteProvider: widget.paletteProvider,
        generatorType: widget.generatorType,
        customPalettePicker: widget.customPalettePicker,
        settingsCubit: widget.settingsCubit,
        showDownloadFab: true,
        showHistoryInControls: true,
        showOverlayInControls: true,
      );
    }

    return Scaffold(
      drawer: widget.showDrawer ? AppDrawer(paths: widget.paths) : null,
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title),
              actions: [
                Builder(
                  builder: (context) {
                    final viewState = _viewKey.currentState;
                    final cubit = viewState?.cubit;
                    if (cubit == null) return const SizedBox.shrink();

                    return BlocBuilder<TriangleGeneratorCubit,
                        TriangleGeneratorState>(
                      bloc: cubit,
                      builder: (context, state) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.paletteSource != null)
                              IconButton(
                                icon: Icon(state.showImageOverlay
                                    ? Icons.image
                                    : Icons.image_outlined),
                                onPressed: cubit.toggleImageOverlay,
                                tooltip: state.showImageOverlay
                                    ? AppStrings.hideReference
                                    : AppStrings.showReference,
                              ),
                            IconButton(
                              icon: const Icon(Icons.history),
                              onPressed: () =>
                                  Scaffold.of(context).openEndDrawer(),
                              tooltip: AppStrings.showHistory,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
          : null,
      endDrawer: Drawer(
        width: 300,
        child: Builder(
          builder: (context) {
            final viewState = _viewKey.currentState;
            final cubit = viewState?.cubit;
            if (viewState == null || cubit == null) return const SizedBox.shrink();

            return BlocBuilder<TriangleGeneratorCubit, TriangleGeneratorState>(
              bloc: cubit,
              builder: (context, state) {
                return viewState.buildHistoryPanel(
                  context: context,
                  state: state,
                  onClose: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      body: TriangleGeneratorView(
        key: _viewKey,
        title: widget.title,
        paletteProvider: widget.paletteProvider,
        generatorType: widget.generatorType,
        customPalettePicker: widget.customPalettePicker,
        settingsCubit: widget.settingsCubit,
        showDownloadFab: true,
        showHistoryInControls: !widget.showAppBar,
        showOverlayInControls: !widget.showAppBar,
      ),
    );
  }
}
