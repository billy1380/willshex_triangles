import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_flutter/extensions/color_ex.dart";

class PalettePickerDialog extends StatefulWidget {
  final ws.Palette? initialPalette;

  const PalettePickerDialog({super.key, this.initialPalette});

  @override
  State<PalettePickerDialog> createState() => _PalettePickerDialogState();
}

class _PalettePickerDialogState extends State<PalettePickerDialog> {
  late final PalettePickerCubit _cubit;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _cubit = PalettePickerCubit(initialPalette: widget.initialPalette);
    _nameController = TextEditingController(text: _cubit.state.name);
  }

  @override
  void dispose() {
    _cubit.close();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PalettePickerCubit, PalettePickerState>(
      bloc: _cubit,
      builder: (context, state) {
        final currentColor = state.currentColor;

        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    widget.initialPalette != null
                        ? AppStrings.editPalette
                        : AppStrings.createCustomPalette,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    onChanged: _cubit.setName,
                    decoration:
                        const InputDecoration(labelText: AppStrings.paletteName),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Scrollbar(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 60,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: state.colors.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.colors.length) {
                            return InkWell(
                              onTap: () => _cubit.addColor(),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add),
                              ),
                            );
                          }

                          final color = state.colors[index];
                          final isSelected = index == state.selectedIndex;

                          return InkWell(
                            onTap: () => _cubit.selectColor(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.toColor(),
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3,
                                      )
                                    : Border.all(color: Colors.black12),
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: const Icon(Icons.close,
                                      size: 16, color: Colors.white),
                                  onPressed: () => _cubit.removeColor(index),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  if (currentColor != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.editColor,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: currentColor.toColor(),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: currentColor.red * 255,
                      min: 0,
                      max: 255,
                      label: AppStrings.labelR,
                      activeColor: Colors.red,
                      onChanged: (v) => _cubit.updateSelectedColor(
                        ws.Color.rgbaColor(
                          v / 255.0,
                          currentColor.green,
                          currentColor.blue,
                          currentColor.alpha,
                        ),
                      ),
                    ),
                    Slider(
                      value: currentColor.green * 255,
                      min: 0,
                      max: 255,
                      label: AppStrings.labelG,
                      activeColor: Colors.green,
                      onChanged: (v) => _cubit.updateSelectedColor(
                        ws.Color.rgbaColor(
                          currentColor.red,
                          v / 255.0,
                          currentColor.blue,
                          currentColor.alpha,
                        ),
                      ),
                    ),
                    Slider(
                      value: currentColor.blue * 255,
                      min: 0,
                      max: 255,
                      label: AppStrings.labelB,
                      activeColor: Colors.blue,
                      onChanged: (v) => _cubit.updateSelectedColor(
                        ws.Color.rgbaColor(
                          currentColor.red,
                          currentColor.green,
                          v / 255.0,
                          currentColor.alpha,
                        ),
                      ),
                    ),
                  ] else
                    const SizedBox(
                      height: 150,
                      child: Center(child: Text(AppStrings.selectColorPrompt)),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(AppStrings.cancel),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: state.colors.isEmpty
                            ? null
                            : () => Navigator.of(context)
                                .pop(_cubit.buildPalette()),
                        child: const Text(AppStrings.select),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
