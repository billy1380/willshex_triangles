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
import "package:client_web/ui/parts/interactive_viewer.dart";
import "package:client_web/ui/parts/palette_history_component.dart";
import "package:client_web/ui/parts/palette_picker_modal.dart";

import "package:client_web/services/local_storage_settings_storage.dart";

/// Pure embeddable view for triangle generator in web.
class TriangleGeneratorView extends StatelessComponent {
  final GeneratorType generatorType;

  const TriangleGeneratorView({
    required this.generatorType,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return TriangleGeneratorScreen(
      generatorType: generatorType,
      useLayout: false,
    );
  }
}

class TriangleGeneratorScreen extends StatefulComponent {
  final GeneratorType generatorType;
  final bool useLayout;
  final TrianglesRoutePaths paths;

  TriangleGeneratorScreen({
    required this.generatorType,
    this.useLayout = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  State<TriangleGeneratorScreen> createState() =>
      _TriangleGeneratorScreenState();
}

class _TriangleGeneratorScreenState extends State<TriangleGeneratorScreen> {
  late final TriangleGeneratorCubit _cubit;
  SettingsCubit? _localSettingsCubit;
  late final SettingsCubit _settingsCubit;
  bool _historyDrawerOpen = false;
  ws.Palette? _editingPalette;
  bool _showCustomPaletteModal = false;

  @override
  void initState() {
    super.initState();
    final cubitFromContext = BlocProvider.maybeOf<SettingsCubit>(context);
    if (cubitFromContext == null) {
      _localSettingsCubit = SettingsCubit(LocalStorageSettingsStorage());
      _settingsCubit = _localSettingsCubit!;
    } else {
      _settingsCubit = cubitFromContext;
    }

    final settingsState = _settingsCubit.state;

    _cubit = TriangleGeneratorCubit(
      title: component.generatorType.title,
      settings: settingsState.settings,
      paletteProvider: component.generatorType.createProvider(
        pickerCallback: () async {
          setState(() => _showCustomPaletteModal = true);
          return null;
        },
        settings: settingsState.settings,
        getSettings: () => _settingsCubit.state.settings,
      ),
      assetLoader: _loadWebAsset,
    );
  }

  static Future<Uint8List?> _loadWebAsset(String path) async {
    try {
      final cleanPath = path.startsWith("/") ? path : "/$path";
      final uri = Uri.base.resolve(cleanPath);
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
    _localSettingsCubit?.close();
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
      bloc: _settingsCubit,
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
                      ? AppStrings.hideReference
                      : AppStrings.showReference,
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
              attributes: const {"title": AppStrings.showHistory},
              events: {
                "click": (e) =>
                    setState(() => _historyDrawerOpen = !_historyDrawerOpen),
              },
              const [
                i(classes: "bi bi-clock-history me-1", []),
                span(classes: "d-none d-sm-inline", [
                  Component.text(AppStrings.history),
                ]),
              ],
            ),
          ];

          final content = div(
            classes: "d-flex flex-column flex-grow-1 position-relative",
              [
                // Top controls bar
                div(classes: "generator-controls", [
                  div(classes: "generator-control-group", [
                    const label([Component.text(AppStrings.type)]),
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
                    const label([Component.text(AppStrings.texture)]),
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
                          const [Component.text(AppStrings.textureNone)],
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
                    const label([Component.text(AppStrings.blendMode)]),
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
                  if (!component.useLayout) ...[
                    if (state.paletteSource != null)
                      button(
                        classes:
                            "btn btn-sm ${state.showImageOverlay ? 'btn-primary' : 'btn-outline-secondary'} ms-auto",
                        attributes: {
                          "title": state.showImageOverlay
                              ? AppStrings.hideReference
                              : AppStrings.showReference,
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
                          "btn btn-sm ${_historyDrawerOpen ? 'btn-primary' : 'btn-outline-secondary'} ${state.paletteSource == null ? 'ms-auto' : ''}",
                      attributes: const {"title": AppStrings.showHistory},
                      events: {
                        "click": (e) => setState(
                            () => _historyDrawerOpen = !_historyDrawerOpen),
                      },
                      const [
                        i(classes: "bi bi-clock-history me-1", []),
                        span(classes: "d-none d-sm-inline", [
                          Component.text(AppStrings.history),
                        ]),
                      ],
                    ),
                  ],
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
                        Component.text(AppStrings.buildingTriangles),
                      ]),
                    ])
                  else if (state.generatedImage != null) ...[
                    InteractiveViewer(
                      child: div(classes: "generated-image-container", [
                        img(
                          classes: "generated-image",
                          src:
                              "data:image/png;base64,${base64Encode(state.generatedImage!)}",
                          alt: AppStrings.generatedTriangles,
                        ),
                      ]),
                    ),
                    if (state.showImageOverlay && state.paletteSource != null)
                      div(classes: "reference-overlay", [
                        img(
                          src:
                              "data:image/png;base64,${base64Encode(image_lib.encodePng(state.paletteSource!))}",
                          alt: AppStrings.referencePaletteSource,
                        ),
                      ]),
                    button(
                      classes: "btn btn-primary btn-fab-download",
                      attributes: const {
                        "title": AppStrings.downloadImage,
                        "aria-label": AppStrings.downloadImage,
                      },
                      events: {
                        "click": (e) => _downloadImage(state.generatedImage!),
                      },
                      const [
                        i(classes: "bi bi-download", []),
                      ],
                    ),
                  ] else
                    div(classes: "text-center text-secondary", [
                      const i(classes: "bi bi-triangle fs-1 mb-3 d-block", []),
                      Component.text(
                          state.errorMessage ?? AppStrings.buildingTriangles),
                      if (component.generatorType ==
                              GeneratorType.palettePicker &&
                          state.currentPalette == null)
                        div(classes: "mt-3", [
                          button(
                            classes: "btn btn-outline-primary",
                            events: {"click": (e) => _cubit.generatePalette()},
                            const [
                              i(classes: "bi bi-palette me-2", []),
                              Component.text(AppStrings.createPalette),
                            ],
                          ),
                        ]),
                    ]),
                ]),

                // Right side History Drawer
                aside(
                  classes: "history-drawer ${_historyDrawerOpen ? 'open' : ''}",
                  [
                    div(classes: "history-drawer-header", [
                      const h5(classes: "m-0 fw-bold", [
                        Component.text(AppStrings.history),
                      ]),
                      div(classes: "d-flex gap-2", [
                        button(
                          classes: "btn btn-sm btn-outline-primary",
                          attributes: const {
                            "title": AppStrings.newPalette,
                          },
                          events: {
                            "click": (e) => _cubit.generatePalette(),
                          },
                          const [i(classes: "bi bi-plus-lg", [])],
                        ),
                        button(
                          classes: "btn btn-sm btn-outline-danger",
                          attributes: const {"title": AppStrings.clearHistory},
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
            );

            if (!component.useLayout) {
              return content;
            }

            return AppLayout(
              title: component.generatorType.title,
              actions: topbarActions,
              paths: component.paths,
              child: content,
            );
          },
        ),
      );
    }
}
