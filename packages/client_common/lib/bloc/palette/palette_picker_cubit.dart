import "package:bloc/bloc.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/bloc/palette/palette_picker_state.dart";

class PalettePickerCubit extends Cubit<PalettePickerState> {
  PalettePickerCubit({ws.Palette? initialPalette})
      : super(PalettePickerState(
          name: initialPalette?.name ?? "My Custom Palette",
          colors: initialPalette != null
              ? List<ws.Color>.from(initialPalette.colors)
              : const [],
          selectedIndex: (initialPalette?.colors.isNotEmpty ?? false) ? 0 : -1,
        )) {
    if (initialPalette == null || initialPalette.colors.isEmpty) {
      addColor();
      addColor();
    }
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void addColor([ws.Color? color]) {
    final updatedColors = List<ws.Color>.from(state.colors);
    ws.Color nextColor;

    if (color != null) {
      nextColor = color;
    } else if (updatedColors.isEmpty) {
      nextColor = ws.NamedColorHelper.randomNamedColor;
    } else {
      final lastColor = updatedColors.last;
      // Slight shift
      final r = (lastColor.red + 0.1) % 1.0;
      final g = (lastColor.green + 0.15) % 1.0;
      final b = (lastColor.blue + 0.2) % 1.0;
      nextColor = ws.Color.rgbaColor(r, g, b, 1.0);
    }

    updatedColors.add(nextColor);
    emit(state.copyWith(
      colors: updatedColors,
      selectedIndex: updatedColors.length - 1,
    ));
  }

  void removeColor(int index) {
    if (index < 0 || index >= state.colors.length) return;
    final updatedColors = List<ws.Color>.from(state.colors)..removeAt(index);
    var newSelectedIndex = state.selectedIndex;
    if (newSelectedIndex >= updatedColors.length) {
      newSelectedIndex = updatedColors.length - 1;
    }
    emit(state.copyWith(
      colors: updatedColors,
      selectedIndex: newSelectedIndex,
    ));
  }

  void selectColor(int index) {
    if (index >= 0 && index < state.colors.length) {
      emit(state.copyWith(selectedIndex: index));
    }
  }

  void updateSelectedColor(ws.Color newColor) {
    if (state.selectedIndex >= 0 && state.selectedIndex < state.colors.length) {
      final updatedColors = List<ws.Color>.from(state.colors);
      updatedColors[state.selectedIndex] = newColor;
      emit(state.copyWith(colors: updatedColors));
    }
  }

  ws.Palette buildPalette() {
    final palette = ws.Palette(state.name);
    palette.addColors(state.colors);
    return palette;
  }
}
