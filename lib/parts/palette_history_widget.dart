import "package:flutter/material.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;

/// A widget that displays a list of palettes history.
/// Each palette is shown with its name and a row of circular color previews.
class PaletteHistoryWidget extends StatelessWidget {
  /// The list of palettes to display
  final List<ws.Palette> palettes;

  /// Callback when a palette is tapped
  final ValueChanged<ws.Palette>? onSelected;

  /// Callback when a palette is deleted (optional)
  final ValueChanged<ws.Palette>? onDelete;

  /// The currently selected palette (for highlighting)
  final ws.Palette? selectedPalette;

  const PaletteHistoryWidget({
    super.key,
    required this.palettes,
    this.onSelected,
    this.onDelete,
    this.selectedPalette,
  });

  @override
  Widget build(BuildContext context) {
    if (palettes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "No history yet",
            style: TextStyle(color: Colors.grey),
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
              palette.name ?? "Untitled Palette",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : null,
                    color: isSelected ? colorScheme.onSecondaryContainer : null,
                  ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children:
                      palette.colors.map((c) => _buildColorCircle(c)).toList(),
                ),
              ),
            ),
            trailing: onDelete != null
                ? IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => onDelete!(palette),
                    color: isSelected ? colorScheme.onSecondaryContainer : null,
                  )
                : null,
            onTap: onSelected != null ? () => onSelected!(palette) : null,
          ),
        );
      },
    );
  }

  Widget _buildColorCircle(ws.Color c) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Color.fromARGB(
          (c.alpha * 255).toInt(),
          (c.red * 255).toInt(),
          (c.green * 255).toInt(),
          (c.blue * 255).toInt(),
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
    );
  }
}
