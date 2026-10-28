import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_web/ui/parts/dialog_frame.dart";

/// A dialog with a grid of every texture, so the choice can be seen before it
/// is made. [assetsBase] is where the package assets are served from.
class TexturePickerModal extends StatelessComponent {
  final TilableImage? selected;
  final String assetsBase;
  final ValueChanged<TilableImage?> onSelect;
  final VoidCallback onCancel;

  const TexturePickerModal({
    required this.selected,
    required this.assetsBase,
    required this.onSelect,
    required this.onCancel,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    return DialogFrame(
      title: AppStrings.chooseTexture,
      dialogClasses: "texture-picker-dialog",
      onClose: onCancel,
      children: [
        div(classes: "texture-picker", [
          _tile(null),
          for (final texture in TilableImage.values) _tile(texture),
        ]),
      ],
      actions: [DialogFrame.textButton(AppStrings.cancel, onCancel)],
    );
  }

  Component _tile(TilableImage? texture) {
    final isSelected = texture == selected;
    final label = texture?.label ?? AppStrings.textureNone;

    return button(
      type: ButtonType.button,
      classes: "texture-picker-item ${isSelected ? 'selected' : ''}",
      attributes: {"aria-pressed": "$isSelected", "title": label},
      events: {"click": (e) => onSelect(texture)},
      [
        if (texture == null)
          const div(
            classes: "texture-picker-none",
            [i(classes: "bi bi-slash-circle", [])],
          )
        else
          img(src: "$assetsBase${texture.path}", alt: label),
        span([Component.text(label)]),
      ],
    );
  }
}
