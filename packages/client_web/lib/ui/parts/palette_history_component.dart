import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_web/ui/helpers/color_css_ex.dart";

class PaletteHistoryComponent extends StatelessComponent {
  final List<ws.Palette> palettes;
  final ws.Palette? selectedPalette;
  final ValueChanged<ws.Palette>? onSelected;
  final ValueChanged<ws.Palette>? onDelete;
  final ValueChanged<ws.Palette>? onEdit;

  const PaletteHistoryComponent({
    required this.palettes,
    this.selectedPalette,
    this.onSelected,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  @override
  Component build(BuildContext context) {
    if (palettes.isEmpty) {
      return const div(classes: "text-center text-secondary p-4", [
        i(
          classes: "bi bi-clock-history fs-1 mb-2 d-block opacity-50",
          [],
        ),
        Component.text(AppStrings.noHistoryYet),
      ]);
    }

    return div(
      classes: "history-list",
      [
        for (final palette in palettes)
          _buildPaletteItem(palette, palette == selectedPalette),
      ],
    );
  }

  Component _buildPaletteItem(ws.Palette palette, bool isSelected) {
    final canEdit = onEdit != null && palette is! FromSource;

    return div(
      classes: "history-item ${isSelected ? 'selected' : ''}",
      events: {
        "click": (e) {
          if (onSelected != null) {
            onSelected!(palette);
          }
        },
      },
      [
        div(classes: "history-item-header", [
          span(classes: "history-item-name", [
            Component.text(palette.name ?? AppStrings.untitledPalette),
          ]),
          div(classes: "d-flex gap-1", [
            if (canEdit)
              button(
                classes: "btn btn-sm btn-link text-secondary p-0 px-1",
                attributes: const {"title": AppStrings.editPalette},
                events: {
                  "click": (e) {
                    onEdit!(palette);
                  },
                },
                const [i(classes: "bi bi-pencil", [])],
              ),
            if (onDelete != null)
              button(
                classes: "btn btn-sm btn-link text-danger p-0 px-1",
                attributes: const {"title": AppStrings.deletePalette},
                events: {
                  "click": (e) {
                    onDelete!(palette);
                  },
                },
                const [i(classes: "bi bi-trash", [])],
              ),
          ]),
        ]),
        div(
          classes: "palette-dots",
          [
            for (final c in palette.colors)
              div(
                classes: "palette-dot",
                attributes: {
                  "style": "background-color: ${c.toCssRgba()};",
                },
                const [],
              ),
          ],
        ),
      ],
    );
  }
}
