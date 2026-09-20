import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:willshex_draw/willshex_draw.dart" as ws;
import "package:client_common/client_common.dart";
import "package:client_web/ui/bloc_provider.dart";
import "package:client_web/ui/helpers/color_css_ex.dart";

class PalettePickerModal extends StatefulComponent {
  final ws.Palette? initialPalette;
  final ValueChanged<ws.Palette> onSelect;
  final VoidCallback onCancel;

  const PalettePickerModal({
    this.initialPalette,
    required this.onSelect,
    required this.onCancel,
    super.key,
  });

  @override
  State<PalettePickerModal> createState() => _PalettePickerModalState();
}

class _PalettePickerModalState extends State<PalettePickerModal> {
  late final PalettePickerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PalettePickerCubit(initialPalette: component.initialPalette);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return BlocBuilder<PalettePickerCubit, PalettePickerState>(
      bloc: _cubit,
      builder: (context, state) {
        final currentColor = state.currentColor;

        return div(
          classes: "modal d-block",
          attributes: const {
            "tabindex": "-1",
            "style": "background-color: rgba(0, 0, 0, 0.5);",
          },
          [
            div(classes: "modal-dialog modal-dialog-centered", [
              div(classes: "modal-content shadow-lg border", [
                div(classes: "modal-header", [
                  h5(classes: "modal-title m-0 fw-bold", [
                    Component.text(component.initialPalette != null
                        ? AppStrings.editPalette
                        : AppStrings.createCustomPalette),
                  ]),
                  button(
                    classes: "btn-close",
                    attributes: const {
                      "title": AppStrings.close,
                      "aria-label": AppStrings.close,
                    },
                    events: {"click": (e) => component.onCancel()},
                    const [],
                  ),
                ]),
                div(classes: "modal-body", [
              div(classes: "mb-3", [
                const label(
                  classes: "form-label text-secondary small fw-bold",
                  [Component.text(AppStrings.paletteName)],
                ),
                input(
                  type: InputType.text,
                  classes: "form-control",
                  value: state.name,
                  events: {
                    "input": (e) {
                      final val = (e.target as dynamic).value as String?;
                      if (val != null) _cubit.setName(val);
                    },
                  },
                ),
              ]),
              div(classes: "swatches-grid", [
                for (var i = 0; i < state.colors.length; i++)
                  _buildSwatch(state.colors[i], i, i == state.selectedIndex),
                div(
                  classes: "swatch-add-card",
                  attributes: const {"title": AppStrings.addColor},
                  events: {"click": (e) => _cubit.addColor()},
                  const [i(classes: "bi bi-plus-lg", [])],
                ),
              ]),
              const hr(),
              if (currentColor != null) ...[
                div(
                  classes:
                      "d-flex align-items-center justify-content-between mb-3",
                  [
                    const span(classes: "fw-bold small", [
                      Component.text(AppStrings.editColor),
                    ]),
                    div(
                      attributes: {
                        "style":
                            "width: 32px; height: 32px; border-radius: 6px; background-color: ${currentColor.toCssRgba()}; border: 1px solid rgba(0,0,0,0.2);",
                      },
                      const [],
                    ),
                  ],
                ),
                _buildSlider(
                  label: AppStrings.red,
                  color: "text-danger",
                  sliderClass: "form-range-red",
                  value: (currentColor.red * 255).round(),
                  onChanged: (val) => _cubit.updateSelectedColor(
                    ws.Color.rgbaColor(
                      val / 255.0,
                      currentColor.green,
                      currentColor.blue,
                      currentColor.alpha,
                    ),
                  ),
                ),
                _buildSlider(
                  label: AppStrings.green,
                  color: "text-success",
                  sliderClass: "form-range-green",
                  value: (currentColor.green * 255).round(),
                  onChanged: (val) => _cubit.updateSelectedColor(
                    ws.Color.rgbaColor(
                      currentColor.red,
                      val / 255.0,
                      currentColor.blue,
                      currentColor.alpha,
                    ),
                  ),
                ),
                _buildSlider(
                  label: AppStrings.blue,
                  color: "text-primary",
                  sliderClass: "form-range-blue",
                  value: (currentColor.blue * 255).round(),
                  onChanged: (val) => _cubit.updateSelectedColor(
                    ws.Color.rgbaColor(
                      currentColor.red,
                      currentColor.green,
                      val / 255.0,
                      currentColor.alpha,
                    ),
                  ),
                ),
              ] else
                const div(classes: "text-center text-secondary py-3", [
                  Component.text(AppStrings.selectColorPrompt),
                ]),
            ]),
                div(classes: "modal-footer", [
                  button(
                    classes: "btn btn-outline-secondary",
                    events: {"click": (e) => component.onCancel()},
                    const [Component.text(AppStrings.cancel)],
                  ),
                  button(
                    classes: "btn btn-primary",
                    disabled: state.colors.isEmpty,
                    events: {
                      "click": (e) {
                        if (state.colors.isNotEmpty) {
                          component.onSelect(_cubit.buildPalette());
                        }
                      },
                    },
                    const [Component.text(AppStrings.select)],
                  ),
                ]),
              ]),
            ]),
          ],
        );
      },
    );
  }

  Component _buildSwatch(ws.Color color, int index, bool isSelected) {
    return div(
      classes: "swatch-card ${isSelected ? 'selected' : ''}",
      attributes: {
        "style": "background-color: ${color.toCssRgba()};",
      },
      events: {
        "click": (e) => _cubit.selectColor(index),
      },
      [
        button(
          classes: "swatch-remove-btn",
          attributes: const {"title": AppStrings.removeColor},
          events: {
            "click": (e) {
              _cubit.removeColor(index);
            },
          },
          const [Component.text("×")],
        ),
      ],
    );
  }

  Component _buildSlider({
    required String label,
    required String color,
    required String sliderClass,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final pct = (value / 255.0 * 100).toStringAsFixed(1);

    return div(classes: "mb-2", [
      div(classes: "d-flex justify-content-between small text-secondary mb-1", [
        span(classes: color, [Component.text(label)]),
        span([Component.text("$value")]),
      ]),
      input(
        type: InputType.range,
        classes: "form-range form-range-colored $sliderClass",
        value: "$value",
        attributes: {
          "min": "0",
          "max": "255",
          "style": "--slider-pct: $pct%;",
        },
        events: {
          "input": (e) {
            final target = e.target as dynamic;
            final val = int.tryParse(target.value as String);
            if (val != null) {
              final newPct = (val / 255.0 * 100).toStringAsFixed(1);
              target.style.setProperty("--slider-pct", "$newPct%");
              onChanged(val);
            }
          },
        },
      ),
    ]);
  }
}
