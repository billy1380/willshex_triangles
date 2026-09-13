import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/bloc_provider.dart";
import "package:client_web/ui/layout.dart";

class SettingsScreen extends StatelessComponent {
  const SettingsScreen({super.key});

  @override
  Component build(BuildContext context) {
    return const AppLayout(
      title: "Settings",
      child: _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatelessComponent {
  const _SettingsContent();

  @override
  Component build(BuildContext context) {
    final cubit = BlocProvider.of<SettingsCubit>(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: cubit,
      builder: (context, state) {
        final s = state.settings;

        return div(
          classes: "p-4 p-md-5 overflow-auto",
          attributes: const {"style": "max-width: 680px; margin: 0 auto;"},
          [
            div(classes: "card p-4 shadow-sm border-0 bg-opacity-50", [
              const h4(classes: "mb-4 fw-bold text-primary", [
                i(classes: "bi bi-sliders me-2", []),
                Component.text("Image Configuration"),
              ]),
              div(classes: "row g-3 mb-3", [
                div(classes: "col-sm-6", [
                  const label(
                    classes: "form-label text-secondary small fw-bold",
                    [Component.text("Image Width (px)")],
                  ),
                  input(
                    type: InputType.number,
                    classes: "form-control",
                    value: "${s.width}",
                    events: {
                      "input": (e) {
                        final val =
                            int.tryParse((e.target as dynamic).value as String);
                        if (val != null) cubit.updateWidth(val);
                      },
                    },
                  ),
                ]),
                div(classes: "col-sm-6", [
                  const label(
                    classes: "form-label text-secondary small fw-bold",
                    [Component.text("Image Height (px)")],
                  ),
                  input(
                    type: InputType.number,
                    classes: "form-control",
                    value: "${s.height}",
                    events: {
                      "input": (e) {
                        final val =
                            int.tryParse((e.target as dynamic).value as String);
                        if (val != null) cubit.updateHeight(val);
                      },
                    },
                  ),
                ]),
              ]),
              div(classes: "mb-4", [
                const label(
                  classes: "form-label text-secondary small fw-bold",
                  [Component.text("Scale Factor (Triangle Size Ratio)")],
                ),
                input(
                  type: InputType.number,
                  classes: "form-control",
                  value: "${s.scaleFactor}",
                  attributes: const {"step": "0.01"},
                  events: {
                    "input": (e) {
                      final val = double.tryParse(
                          (e.target as dynamic).value as String);
                      if (val != null) cubit.updateScaleFactor(val);
                    },
                  },
                ),
              ]),
              const hr(),
              div(classes: "form-check form-switch my-3", [
                input(
                  type: InputType.checkbox,
                  classes: "form-check-input",
                  id: "checkGradients",
                  checked: s.addTriangleGradients,
                  events: {
                    "change": (e) {
                      final val = (e.target as dynamic).checked as bool;
                      cubit.updateAddTriangleGradients(val);
                    },
                  },
                ),
                const label(
                  classes: "form-check-label ms-2 fw-medium",
                  attributes: {"for": "checkGradients"},
                  [Component.text("Add triangle gradients")],
                ),
              ]),
              div(classes: "form-check form-switch my-3", [
                input(
                  type: InputType.checkbox,
                  classes: "form-check-input",
                  id: "checkAnnotate",
                  checked: s.annotateWithDimensions,
                  events: {
                    "change": (e) {
                      final val = (e.target as dynamic).checked as bool;
                      cubit.updateAnnotateWithDimensions(val);
                    },
                  },
                ),
                const label(
                  classes: "form-check-label ms-2 fw-medium",
                  attributes: {"for": "checkAnnotate"},
                  [Component.text("Annotate with dimensions")],
                ),
              ]),
            ]),
          ],
        );
      },
    );
  }
}
