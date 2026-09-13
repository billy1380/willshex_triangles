import "dart:convert";
import "dart:typed_data";

import "package:blend_composites/blend_composites.dart";
import "package:http/http.dart" as http;
import "package:image/image.dart" as image_lib;
import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:web/web.dart" as web;
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_web/ui/bloc_provider.dart";
import "package:client_web/ui/layout.dart";
import "package:client_web/ui/parts/palette_history_component.dart";
import "package:client_web/ui/parts/palette_picker_modal.dart";

class TriangleGeneratorScreen extends StatefulComponent {
  final GeneratorType generatorType;

  const TriangleGeneratorScreen({
    required this.generatorType,
    super.key,
  });

  @override
  State<TriangleGeneratorScreen> createState() =>
      _TriangleGeneratorScreenState();
}

class _TriangleGeneratorScreenState extends State<TriangleGeneratorScreen> {
  late final TriangleGeneratorCubit _cubit;
  bool _historyDrawerOpen = false;
  ws.Palette? _editingPalette;
  bool _showCustomPaletteModal = false;

  @override
  void initState() {
    super.initState();
    final settingsState = BlocProvider.of<SettingsCubit>(context).state;

    _cubit = TriangleGeneratorCubit(
      title: component.generatorType.title,
      settings: settingsState.settings,
      paletteProvider: component.generatorType.createProvider(
        pickerCallback: () async {
          setState(() => _showCustomPaletteModal = true);
          return null;
        },
        settings: settingsState.settings,
      ),
      assetLoader: _loadWebAsset,
    );
  }

  static Future<Uint8List?> _loadWebAsset(String path) async {
    try {
      final uri = Uri.base.resolve(path);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (_) {}
    return null;
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _downloadImage(Uint8List bytes) {
    final base64Data = base64Encode(bytes);
    final link = web.document.createElement("a") as web.HTMLAnchorElement;
    link.href = "data:image/png;base64,$base64Data";
    link.download = "triangles.png";
    link.click();
  }

  @override
  Component build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listener: (context, settingsState) {
        _cubit.updateSettings(settingsState.settings);
      },
      child: BlocBuilder<TriangleGeneratorCubit, TriangleGeneratorState>(
        bloc: _cubit,
        builder: (context, state) {
          final topbarActions = [
            if (state.paletteSource != null)
              button(
                classes:
                    "btn btn-sm ${state.showImageOverlay ? 'btn-primary' : 'btn-outline-secondary'}",
                attributes: {
                  "title": state.showImageOverlay
                      ? "Hide Reference"
                      : "Show Reference",
                },
                events: {"click": (e) => _cubit.toggleImageOverlay()},
                [
                  i(
                    classes:
                        "bi ${state.showImageOverlay ? 'bi-image-fill' : 'bi-image'}",
                    const [],
                  ),
                ],
              ),
            button(
              classes:
                  "btn btn-sm ${_historyDrawerOpen ? 'btn-primary' : 'btn-outline-secondary'}",
              attributes: const {"title": "Show History"},
              events: {
                "click": (e) =>
                    setState(() => _historyDrawerOpen = !_historyDrawerOpen),
              },
              const [
                i(classes: "bi bi-clock-history me-1", []),
                span(classes: "d-none d-sm-inline", [
                  Component.text("History"),
                ]),
              ],
            ),
          ];

          return AppLayout(
            title: component.generatorType.title,
            actions: topbarActions,
            child: div(
              classes: "d-flex flex-column flex-grow-1 position-relative",
              [
                // Top controls bar
                div(classes: "generator-controls", [
                  div(classes: "generator-control-group", [
                    const label([Component.text("Pattern Type")]),
                    select(
                      classes: "form-select form-select-sm",
                      events: {
                        "change": (e) {
                          final val = (e.target as dynamic).value as String;
                          final type = TrianglesType.values.firstWhere(
                            (t) => t.name == val,
                            orElse: () => TrianglesType.ribbons,
                          );
                          _cubit.selectType(type);
                        },
                      },
                      [
                        for (final type in TrianglesType.values)
                          option(
                            value: type.name,
                            selected: type == state.selectedType,
                            [Component.text(type.name)],
                          ),
                      ],
                    ),
                  ]),
                  div(classes: "generator-control-group", [
                    const label([Component.text("Texture Pattern")]),
                    select(
                      classes: "form-select form-select-sm",
                      events: {
                        "change": (e) {
                          final val = (e.target as dynamic).value as String;
                          if (val == "none") {
                            _cubit.selectTexture(null);
                          } else {
                            final match = TilableImage.values.firstWhere(
                              (imgItem) => imgItem.name == val,
                            );
                            _cubit.selectTexture(match);
                          }
                        },
                      },
                      [
                        option(
                          value: "none",
                          selected: state.selectedImage == null,
                          const [Component.text("None")],
                        ),
                        for (final imgItem in TilableImage.values)
                          option(
                            value: imgItem.name,
                            selected: state.selectedImage == imgItem,
                            [Component.text(imgItem.name)],
                          ),
                      ],
                    ),
                  ]),
                  div(classes: "generator-control-group", [
                    const label([Component.text("Blend Mode")]),
                    select(
                      classes: "form-select form-select-sm",
                      disabled: state.selectedImage == null,
                      events: {
                        "change": (e) {
                          final val = (e.target as dynamic).value as String;
                          final mode = BlendingMode.values.firstWhere(
                            (m) => m.name == val,
                            orElse: () => BlendingMode.colorBurn,
                          );
                          _cubit.selectBlendMode(mode);
                        },
                      },
                      [
                        for (final mode in state.sortedBlendModes)
                          option(
                            value: mode.name,
                            selected: mode == state.selectedBlendMode,
                            [Component.text(mode.name)],
                          ),
                      ],
                    ),
                  ]),
                ]),

                // Canvas viewport
                div(classes: "generator-canvas-area", [
                  if (state.isGenerating)
                    const div(classes: "text-center", [
                      div(
                        classes: "spinner-border text-primary mb-3",
                        attributes: {"role": "status"},
                        [],
                      ),
                      p(classes: "text-secondary fw-medium", [
                        Component.text("Generating triangles..."),
                      ]),
                    ])
                  else if (state.generatedImage != null) ...[
                    div(classes: "generated-image-container", [
                      img(
                        classes: "generated-image",
                        src:
                            "data:image/png;base64,${base64Encode(state.generatedImage!)}",
                        alt: "Generated Triangles",
                      ),
                    ]),
                    if (state.showImageOverlay && state.paletteSource != null)
                      div(classes: "reference-overlay", [
                        img(
                          src:
                              "data:image/png;base64,${base64Encode(image_lib.encodePng(state.paletteSource!))}",
                          alt: "Reference Palette Source",
                        ),
                      ]),
                    button(
                      classes: "btn btn-primary btn-fab-download",
                      events: {
                        "click": (e) => _downloadImage(state.generatedImage!),
                      },
                      const [
                        i(classes: "bi bi-download", []),
                        Component.text("Download Image"),
                      ],
                    ),
                  ] else
                    div(classes: "text-center text-secondary", [
                      const i(classes: "bi bi-triangle fs-1 mb-3 d-block", []),
                      Component.text(
                          state.errorMessage ?? "Building Triangles..."),
                    ]),
                ]),

                // Right side History Drawer
                aside(
                  classes: "history-drawer ${_historyDrawerOpen ? 'open' : ''}",
                  [
                    div(classes: "history-drawer-header", [
                      const h5(classes: "m-0 fw-bold", [
                        Component.text("History"),
                      ]),
                      div(classes: "d-flex gap-2", [
                        button(
                          classes: "btn btn-sm btn-outline-primary",
                          attributes: const {
                            "title": "Generate New Palette",
                          },
                          events: {
                            "click": (e) => _cubit.generatePalette(),
                          },
                          const [i(classes: "bi bi-plus-lg", [])],
                        ),
                        button(
                          classes: "btn btn-sm btn-outline-danger",
                          attributes: const {"title": "Clear History"},
                          events: {"click": (e) => _cubit.clearHistory()},
                          const [i(classes: "bi bi-trash", [])],
                        ),
                        button(
                          classes: "btn btn-sm btn-link text-secondary",
                          events: {
                            "click": (e) =>
                                setState(() => _historyDrawerOpen = false),
                          },
                          const [i(classes: "bi bi-x-lg", [])],
                        ),
                      ]),
                    ]),
                    PaletteHistoryComponent(
                      palettes: state.history,
                      selectedPalette: state.currentPalette,
                      onSelected: (palette) => _cubit.selectPalette(palette),
                      onEdit: (palette) =>
                          setState(() => _editingPalette = palette),
                      onDelete: state.history.length <= 1
                          ? null
                          : (palette) => _cubit.deletePalette(palette),
                    ),
                  ],
                ),

                // Palette picker modal (edit or new custom palette)
                if (_editingPalette != null)
                  PalettePickerModal(
                    initialPalette: _editingPalette,
                    onSelect: (newPalette) {
                      _cubit.updatePalette(_editingPalette!, newPalette);
                      setState(() => _editingPalette = null);
                    },
                    onCancel: () => setState(() => _editingPalette = null),
                  ),

                if (_showCustomPaletteModal)
                  PalettePickerModal(
                    onSelect: (newPalette) {
                      _cubit.selectPalette(newPalette);
                      setState(() => _showCustomPaletteModal = false);
                    },
                    onCancel: () =>
                        setState(() => _showCustomPaletteModal = false),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
