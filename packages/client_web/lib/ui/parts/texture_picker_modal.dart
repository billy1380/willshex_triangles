import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:triangles_common/client_common.dart";

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
    return div(
      classes: "modal d-block",
      attributes: const {
        "tabindex": "-1",
        "style": "background-color: rgba(0, 0, 0, 0.5);",
      },
      events: {"click": (e) => onCancel()},
      [
        div(
          classes:
              "modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable",
          events: {"click": (e) => e.stopPropagation()},
          [
            div(classes: "modal-content shadow-lg border", [
              div(classes: "modal-header", [
                h5(classes: "modal-title m-0 fw-bold", [
                  Component.text(AppStrings.chooseTexture),
                ]),
                button(
                  classes: "btn-close",
                  attributes: const {
                    "title": AppStrings.close,
                    "aria-label": AppStrings.close,
                  },
                  events: {"click": (e) => onCancel()},
                  const [],
                ),
              ]),
              div(classes: "modal-body", [
                div(classes: "row row-cols-4 row-cols-sm-6 row-cols-md-8 g-1", [
                  _tile(null),
                  for (final texture in TilableImage.values) _tile(texture),
                ]),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  Component _tile(TilableImage? texture) {
    final isSelected = texture == selected;

    return div(classes: "col", [
      button(
        classes:
            "btn w-100 p-1 d-flex flex-column align-items-center gap-1 ${isSelected ? 'btn-primary' : 'btn-outline-secondary'}",
        attributes: {
          "type": "button",
          "aria-pressed": "$isSelected",
          "title": texture?.label ?? AppStrings.textureNone,
        },
        events: {"click": (e) => onSelect(texture)},
        [
          if (texture == null)
            const div(
              classes: "d-flex align-items-center justify-content-center",
              attributes: {"style": "width: 100%; aspect-ratio: 1;"},
              [i(classes: "bi bi-slash-circle fs-5", [])],
            )
          else
            img(
              src: "$assetsBase${texture.path}",
              alt: texture.label,
              classes: "rounded",
              attributes: const {
                "style":
                    "width: 100%; aspect-ratio: 1; object-fit: cover; display: block;",
              },
            ),
          span(
            classes: "w-100 lh-sm text-break",
            attributes: const {"style": "font-size: 0.7rem;"},
            [Component.text(texture?.label ?? AppStrings.textureNone)],
          ),
        ],
      ),
    ]);
  }
}
