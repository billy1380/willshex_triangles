import "package:client_common/client_common.dart";
import "package:client_flutter/extensions/color_ex.dart";
import "package:flutter/material.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;

/// A widget that displays a list of palettes history.
/// Each palette is shown with its name and a row of circular color previews.
class PaletteHistory extends StatelessWidget {
  /// The list of palettes to display
  final List<ws.Palette> palettes;

  /// Callback when a palette is tapped
  final ValueChanged<ws.Palette>? onSelected;

  /// Callback when a palette is deleted (optional)
  final ValueChanged<ws.Palette>? onDelete;

  /// Callback when a palette is edited (optional)
  final ValueChanged<ws.Palette>? onEdit;

  /// The currently selected palette (for highlighting)
  final ws.Palette? selectedPalette;

  const PaletteHistory({
    super.key,
    required this.palettes,
    this.onSelected,
    this.onDelete,
    this.onEdit,
    this.selectedPalette,
  });

  @override
  Widget build(BuildContext context) {
    if (palettes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            AppStrings.noHistoryYet,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: palettes.length,
      itemBuilder: (context, index) {
        final palette = palettes[index];
        final isSelected = palette == selectedPalette;
        final colorScheme = Theme.of(context).colorScheme;

        return Card(
          elevation: isSelected ? 2 : 0,
          color: isSelected
              ? colorScheme.secondaryContainer
              : colorScheme.surfaceContainerLow,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          clipBehavior: Clip.hardEdge,
          child: ListTile(
            selected: isSelected,
            selectedColor: colorScheme.onSecondaryContainer,
            title: Text(
              palette.name ?? AppStrings.untitledPalette,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                    color: isSelected ? colorScheme.onSecondaryContainer : null,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: palette.colors
                        .map((c) => _buildColorCircle(context, c))
                        .toList(),
                  ),
                ),
              ),
            ),
            trailing: (onEdit != null || onDelete != null)
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null && palette is! FromSource)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => onEdit!(palette),
                          color: isSelected
                              ? colorScheme.onSecondaryContainer
                              : null,
                          tooltip: AppStrings.editPalette,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => onDelete!(palette),
                          color: isSelected
                              ? colorScheme.onSecondaryContainer
                              : null,
                          tooltip: AppStrings.deletePalette,
                        ),
                    ],
                  )
                : null,
            onTap: onSelected != null ? () => onSelected!(palette) : null,
          ),
        );
      },
    );
  }

  Widget _buildColorCircle(BuildContext context, ws.Color c) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: c.toColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
    );
  }
}
