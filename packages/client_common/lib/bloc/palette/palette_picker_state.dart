import "package:equatable/equatable.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;

class PalettePickerState extends Equatable {
  final String name;
  final List<ws.Color> colors;
  final int selectedIndex;

  const PalettePickerState({
    required this.name,
    required this.colors,
    required this.selectedIndex,
  });

  ws.Color? get currentColor {
    if (selectedIndex >= 0 && selectedIndex < colors.length) {
      return colors[selectedIndex];
    }
    return null;
  }

  PalettePickerState copyWith({
    String? name,
    List<ws.Color>? colors,
    int? selectedIndex,
  }) {
    return PalettePickerState(
      name: name ?? this.name,
      colors: colors ?? this.colors,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [name, colors, selectedIndex];
}
