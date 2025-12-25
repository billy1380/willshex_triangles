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

  const PaletteHistoryWidget({
    super.key,
    required this.palettes,
    this.onSelected,
    this.onDelete,
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
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(
              palette.name ?? "Untitled Palette",
              style: Theme.of(context).textTheme.titleSmall,
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
