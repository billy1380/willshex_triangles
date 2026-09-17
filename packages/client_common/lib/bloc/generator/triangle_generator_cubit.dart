import "dart:typed_data";
import "package:blend_composites/blend_composites.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/bloc/generator/triangle_generator_state.dart";
import "package:client_common/models/generator_settings.dart";
import "package:client_common/triangles/graphics/palette_provider/generator_palette_provider.dart";
import "package:client_common/triangles/graphics/palette_provider/palette_provider.dart";
import "package:client_common/triangles/image_generator.dart";
import "package:client_common/triangles/image_generator_config.dart";
import "package:client_common/triangles/triangles_type.dart";
import "package:client_common/constants/app_strings.dart";

typedef AssetLoader = Future<Uint8List?> Function(String path);

class TriangleGeneratorCubit extends Cubit<TriangleGeneratorState> {
  static final Logger _log = Logger("TriangleGeneratorCubit");
  final AssetLoader? assetLoader;

  TriangleGeneratorCubit({
    required String title,
    required PaletteProvider paletteProvider,
    GeneratorSettings settings = const GeneratorSettings(),
    this.assetLoader,
    TrianglesType initialType = TrianglesType.ribbons,
    TilableImage? initialImage,
    BlendingMode initialBlendMode = BlendingMode.colorBurn,
  }) : super(TriangleGeneratorState(
          title: title,
          paletteProvider: paletteProvider,
          settings: settings,
          selectedType: initialType,
          selectedImage: initialImage,
          selectedBlendMode: initialBlendMode,
        )) {
    generatePalette();
  }

  Future<void> generatePalette() async {
    try {
      final palette = await state.paletteProvider();
      if (palette != null) {
        final newHistory = [palette, ...state.history];
        emit(state.copyWith(
          currentPalette: () => palette,
          history: newHistory,
          errorMessage: () => null,
        ));
        await generateImage();
      } else {
        if (state.history.isEmpty) {
          emit(state.copyWith(
            errorMessage: () => AppStrings.noPaletteProvided,
          ));
        }
      }
    } catch (e, stack) {
      _log.severe(AppStrings.errorGeneratingPalette, e, stack);
      emit(state.copyWith(errorMessage: () => e.toString()));
    }
  }

  Future<void> generateImage() async {
    if (state.currentPalette == null) {
      return;
    }

    emit(state.copyWith(isGenerating: true));

    try {
      final s = state.settings;
      final properties = <String, String>{
        ImageGeneratorConfig.typeKey: state.selectedType.name,
        ImageGeneratorConfig.widthKey: s.width.toString(),
        ImageGeneratorConfig.heightKey: s.height.toString(),
        ImageGeneratorConfig.ratioNKey: s.ratioN.toString(),
        ImageGeneratorConfig.ratioDKey: s.ratioD.toString(),
        ImageGeneratorConfig.addGameGradientsKey:
            s.addTriangleGradients ? "1" : "0",
        ImageGeneratorConfig.annotateKey: s.annotateWithDimensions ? "1" : "0",
      };

      if (state.selectedImage != null) {
        properties[ImageGeneratorConfig.textureKey] = state.selectedImage!.path;
        properties[ImageGeneratorConfig.compositeKey] =
            state.selectedBlendMode.name;
      }

      final storeImage = await ImageGenerator.generateImage(
        properties,
        GeneratorPaletteProvider(() async => state.currentPalette),
        null,
        assetLoader: assetLoader,
      );

      if (storeImage?.content != null) {
        emit(state.copyWith(
          generatedImage: () => Uint8List.fromList(storeImage!.content!),
          isGenerating: false,
          errorMessage: () => null,
        ));
      } else {
        emit(state.copyWith(isGenerating: false));
      }
    } catch (e, stack) {
      _log.severe(AppStrings.errorGeneratingImage, e, stack);
      emit(state.copyWith(
        isGenerating: false,
        errorMessage: () => e.toString(),
      ));
    }
  }

  void selectType(TrianglesType type) {
    if (state.selectedType != type) {
      emit(state.copyWith(selectedType: type));
      generateImage();
    }
  }

  void selectTexture(TilableImage? image) {
    emit(state.copyWith(selectedImage: () => image));
    generateImage();
  }

  void selectBlendMode(BlendingMode mode) {
    if (state.selectedBlendMode != mode) {
      emit(state.copyWith(selectedBlendMode: mode));
      generateImage();
    }
  }

  void selectPalette(ws.Palette palette) {
    final history = state.history.contains(palette)
        ? state.history
        : [palette, ...state.history];
    emit(state.copyWith(
      currentPalette: () => palette,
      history: history,
      errorMessage: () => null,
    ));
    generateImage();
  }

  void updatePalette(ws.Palette oldPalette, ws.Palette newPalette) {
    final index = state.history.indexOf(oldPalette);
    if (index != -1) {
      final updatedHistory = List<ws.Palette>.from(state.history);
      updatedHistory[index] = newPalette;
      final isCurrent = state.currentPalette == oldPalette;
      emit(state.copyWith(
        history: updatedHistory,
        currentPalette: isCurrent ? () => newPalette : null,
      ));
      if (isCurrent) {
        generateImage();
      }
    }
  }

  void deletePalette(ws.Palette palette) {
    final updatedHistory = List<ws.Palette>.from(state.history)
      ..remove(palette);
    final isCurrent = state.currentPalette == palette;
    final nextPalette = isCurrent
        ? (updatedHistory.isNotEmpty ? updatedHistory.first : null)
        : state.currentPalette;

    emit(state.copyWith(
      history: updatedHistory,
      currentPalette: () => nextPalette,
    ));

    if (isCurrent && nextPalette != null) {
      generateImage();
    }
  }

  void clearHistory() {
    emit(state.copyWith(
      history: const [],
      currentPalette: () => null,
      generatedImage: () => null,
    ));
    generatePalette();
  }

  void toggleImageOverlay() {
    emit(state.copyWith(showImageOverlay: !state.showImageOverlay));
  }

  void updateSettings(GeneratorSettings settings) {
    emit(state.copyWith(settings: settings));
    generateImage();
  }
}
