import "dart:typed_data";
import "package:blend_composites/blend_composites.dart";
import "package:equatable/equatable.dart";
import "package:image/image.dart" as img;
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/models/generator_settings.dart";
import "package:client_common/triangles/graphics/from_source.dart";
import "package:client_common/triangles/graphics/palette_provider/palette_provider.dart";
import "package:client_common/triangles/triangles_type.dart";

class TriangleGeneratorState extends Equatable {
  final String title;
  final PaletteProvider paletteProvider;
  final TrianglesType selectedType;
  final TilableImage? selectedImage;
  final BlendingMode selectedBlendMode;
  final ws.Palette? currentPalette;
  final List<ws.Palette> history;
  final Uint8List? generatedImage;
  final bool isGenerating;
  final bool showImageOverlay;
  final GeneratorSettings settings;
  final String? errorMessage;

  const TriangleGeneratorState({
    required this.title,
    required this.paletteProvider,
    this.selectedType = TrianglesType.ribbons,
    this.selectedImage,
    this.selectedBlendMode = BlendingMode.colorBurn,
    this.currentPalette,
    this.history = const [],
    this.generatedImage,
    this.isGenerating = false,
    this.showImageOverlay = true,
    this.settings = const GeneratorSettings(),
    this.errorMessage,
  });

  img.Image? get paletteSource {
    if (currentPalette is FromSource) {
      return (currentPalette as FromSource).source;
    }
    return null;
  }

  List<BlendingMode> get sortedBlendModes {
    final list = BlendingMode.values.toList();
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  TriangleGeneratorState copyWith({
    String? title,
    PaletteProvider? paletteProvider,
    TrianglesType? selectedType,
    TilableImage? Function()? selectedImage,
    BlendingMode? selectedBlendMode,
    ws.Palette? Function()? currentPalette,
    List<ws.Palette>? history,
    Uint8List? Function()? generatedImage,
    bool? isGenerating,
    bool? showImageOverlay,
    GeneratorSettings? settings,
    String? Function()? errorMessage,
  }) {
    return TriangleGeneratorState(
      title: title ?? this.title,
      paletteProvider: paletteProvider ?? this.paletteProvider,
      selectedType: selectedType ?? this.selectedType,
      selectedImage:
          selectedImage != null ? selectedImage() : this.selectedImage,
      selectedBlendMode: selectedBlendMode ?? this.selectedBlendMode,
      currentPalette:
          currentPalette != null ? currentPalette() : this.currentPalette,
      history: history ?? this.history,
      generatedImage:
          generatedImage != null ? generatedImage() : this.generatedImage,
      isGenerating: isGenerating ?? this.isGenerating,
      showImageOverlay: showImageOverlay ?? this.showImageOverlay,
      settings: settings ?? this.settings,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        title,
        paletteProvider,
        selectedType,
        selectedImage,
        selectedBlendMode,
        currentPalette,
        history,
        generatedImage,
        isGenerating,
        showImageOverlay,
        settings,
        errorMessage,
      ];
}
