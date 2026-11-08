import "package:triangles_common/bloc/palette/palette_picker_cubit.dart";
import "package:triangles_common/constants/app_strings.dart";
import "package:triangles_common/dialogs/triangles_dialogs.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:willshex_embedding/willshex_embedding.dart";

/// The palette dialog, to make a palette or edit one: its name, its colours,
/// and the red, green and blue of the colour being edited. Written once as a
/// [DialogRequest] that every client, and every host, draws as a Material
/// dialog in its own way.
///
/// The form owns a [PalettePickerCubit] and answers every change a person makes
/// with the request to show next.
class PaletteForm {
  static const String nameId = "name";
  static const String coloursId = "colours";
  static const String redId = "red";
  static const String greenId = "green";
  static const String blueId = "blue";
  static const String selectId = "select";

  final PalettePickerCubit _cubit;
  final bool _isEditing;

  /// Starts on [initialPalette] to edit it, or on a new palette of two colours.
  PaletteForm({ws.Palette? initialPalette})
      : _cubit = PalettePickerCubit(initialPalette: initialPalette),
        _isEditing = initialPalette != null;

  /// `0xAARRGGBB` of a colour.
  static int argbOf(ws.Color color) {
    int channel(double v) => (v * 255).round().clamp(0, 255);

    return (channel(color.alpha) << 24) |
        (channel(color.red) << 16) |
        (channel(color.green) << 8) |
        channel(color.blue);
  }

  /// The dialog for the palette as it is now.
  DialogRequest request() {
    final state = _cubit.state;
    final ws.Color? current = state.currentColor;

    DialogSlider channel(String id, String label, int accent, double value) =>
        DialogSlider(
          id: id,
          label: label,
          min: 0,
          max: 255,
          value: (value * 255).roundToDouble(),
          accent: accent,
        );

    return DialogRequest(
      title:
          _isEditing ? AppStrings.editPalette : AppStrings.createCustomPalette,
      controls: [
        DialogField(
          id: nameId,
          label: AppStrings.paletteName,
          initialValue: state.name,
        ),
        DialogSwatches(
          id: coloursId,
          colours: [for (final ws.Color c in state.colors) argbOf(c)],
          selected: state.selectedIndex < 0 ? null : state.selectedIndex,
          addLabel: AppStrings.addColor,
          removeLabel: AppStrings.removeColor,
        ),
        if (current == null)
          const DialogText(id: "hint", text: AppStrings.selectColorPrompt)
        else ...[
          DialogPreview(
            id: "preview",
            label: AppStrings.editColor,
            colour: argbOf(current),
          ),
          channel(redId, AppStrings.red, 0xFFDC3545, current.red),
          channel(greenId, AppStrings.green, 0xFF198754, current.green),
          channel(blueId, AppStrings.blue, 0xFF0D6EFD, current.blue),
        ],
      ],
      actions: [
        const DialogAction.cancel(label: AppStrings.cancel),
        DialogAction(
          id: selectId,
          label: AppStrings.select,
          variant: ActionVariant.primary,
          isEnabled: state.colors.isNotEmpty,
        ),
      ],
      onChanged: _changed,
    );
  }

  DialogRequest? _changed(DialogChange change) {
    final ws.Color? current = _cubit.state.currentColor;

    switch (change.controlId) {
      case nameId:
        // the host keeps the text, and hands it back with the answer
        _cubit.setName(change.value as String);

        return null;
      case coloursId:
        switch (change.kind) {
          case DialogChangeKind.select:
            _cubit.selectColor(change.index!);
          case DialogChangeKind.add:
            _cubit.addColor();
          case DialogChangeKind.remove:
            _cubit.removeColor(change.index!);
          case DialogChangeKind.value:
            return null;
        }
      case redId || greenId || blueId:
        if (current == null) return null;

        final double v = (change.value as double).round() / 255;

        _cubit.updateSelectedColor(
          ws.Color.rgbaColor(
            change.controlId == redId ? v : current.red,
            change.controlId == greenId ? v : current.green,
            change.controlId == blueId ? v : current.blue,
            current.alpha,
          ),
        );
      default:
        return null;
    }

    return request();
  }

  /// The palette as the form has it, under [name] if there is one.
  ws.Palette build({String? name}) {
    if (name != null && name.isNotEmpty) _cubit.setName(name);

    return _cubit.buildPalette();
  }

  void close() => _cubit.close();

  /// Asks for a palette to make, or to edit if [initialPalette] is given.
  /// Answers `null` if it was cancelled.
  static Future<ws.Palette?> ask({ws.Palette? initialPalette}) async {
    final PaletteForm form = PaletteForm(initialPalette: initialPalette);

    try {
      final DialogResult? result = await TrianglesDialogs.ask(form.request());

      return result?.actionId == selectId
          ? form.build(name: result!.values[nameId])
          : null;
    } finally {
      form.close();
    }
  }
}
