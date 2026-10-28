import "package:flutter/material.dart";
import "package:subtle_backgrounds/subtle_backgrounds.dart";
import "package:triangles_common/client_common.dart";

/// A field showing the chosen texture that opens a dialog with a grid of every
/// texture, so the choice can be seen before it is made.
class TexturePicker extends StatelessWidget {
  static const int _columns = 8;

  final TilableImage? value;
  final ValueChanged<TilableImage?> onChanged;

  const TexturePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  Future<void> _choose(BuildContext context) async {
    final choice = await showDialog<(TilableImage?,)>(
      context: context,
      builder: _dialog,
    );
    if (choice == null) return;

    onChanged(choice.$1);
  }

  @override
  Widget build(BuildContext context) {
    final texture = value;

    return InkWell(
      onTap: () => _choose(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: AppStrings.texture,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        child: Row(
          children: [
            if (texture != null) ...[
              _thumbnail(texture, 24),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                texture?.label ?? AppStrings.textureNone,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialog(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                AppStrings.chooseTexture,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Flexible(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: _columns,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                childAspectRatio: 0.75,
                children: [
                  _tile(context, null),
                  for (final texture in TilableImage.values)
                    _tile(context, texture),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.cancel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, TilableImage? texture) {
    final colors = Theme.of(context).colorScheme;
    final selected = texture == value;
    final foreground =
        selected ? colors.onSecondaryContainer : colors.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: selected ? colors.secondaryContainer : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).pop((texture,)),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                Expanded(
                  child: texture == null
                      ? Center(child: Icon(Icons.block, color: foreground))
                      : _thumbnail(texture, null),
                ),
                const SizedBox(height: 3),
                Text(
                  texture?.label ?? AppStrings.textureNone,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbnail(TilableImage texture, double? size) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size == null ? 8 : 4),
      child: Image.asset(
        texture.path,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
