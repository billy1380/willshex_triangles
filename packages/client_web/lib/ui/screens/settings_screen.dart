import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:client_common/client_common.dart";
import "package:client_web/ui/bloc_provider.dart";
import "package:client_web/ui/layout.dart";

import "package:client_web/services/local_storage_settings_storage.dart";

class SettingsScreen extends StatelessComponent {
  final bool useLayout;
  final TrianglesRoutePaths paths;

  SettingsScreen({
    this.useLayout = true,
    TrianglesRoutePaths? paths,
    String? basePath,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  Component build(BuildContext context) {
    if (!useLayout) {
      return const SettingsView();
    }
    return AppLayout(
      title: AppStrings.navSettings,
      paths: paths,
      child: const SettingsView(),
    );
  }
}

/// Pure embeddable view for Settings in web.
class SettingsView extends StatefulComponent {
  final SettingsCubit? settingsCubit;

  const SettingsView({this.settingsCubit, super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsCubit? _localSettingsCubit;
  late final SettingsCubit _cubit;

  @override
  void initState() {
    super.initState();
    if (component.settingsCubit != null) {
      _cubit = component.settingsCubit!;
    } else {
      final fromContext = BlocProvider.maybeOf<SettingsCubit>(context);
      if (fromContext != null) {
        _cubit = fromContext;
      } else {
        _localSettingsCubit = SettingsCubit(LocalStorageSettingsStorage());
        _cubit = _localSettingsCubit!;
      }
    }
  }

  @override
  void dispose() {
    _localSettingsCubit?.close();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: _cubit,
      builder: (context, state) {
        final s = state.settings;

        return div(
          classes: "p-4 p-md-5 overflow-auto",
          attributes: const {"style": "max-width: 680px; margin: 0 auto;"},
          [
            div(classes: "card p-4 shadow-sm border-0 bg-opacity-50", [
              const h4(classes: "mb-4 fw-bold text-primary", [
                i(classes: "bi bi-sliders me-2", []),
                Component.text(AppStrings.imageConfiguration),
              ]),
              div(classes: "row g-3 mb-3", [
                div(classes: "col-sm-6", [
                  const label(
                    classes: "form-label text-secondary small fw-bold",
                    [Component.text(AppStrings.imageWidth)],
                  ),
                  input(
                    type: InputType.number,
                    classes: "form-control",
                    value: "${s.width}",
                    events: {
                      "input": (e) {
                        final val =
                            int.tryParse((e.target as dynamic).value as String);
                        if (val != null) _cubit.updateWidth(val);
                      },
                    },
                  ),
                ]),
                div(classes: "col-sm-6", [
                  const label(
                    classes: "form-label text-secondary small fw-bold",
                    [Component.text(AppStrings.imageHeight)],
                  ),
                  input(
                    type: InputType.number,
                    classes: "form-control",
                    value: "${s.height}",
                    events: {
                      "input": (e) {
                        final val =
                            int.tryParse((e.target as dynamic).value as String);
                        if (val != null) _cubit.updateHeight(val);
                      },
                    },
                  ),
                ]),
              ]),
              div(classes: "mb-4", [
                const label(
                  classes: "form-label text-secondary small fw-bold",
                  [Component.text(AppStrings.scaleFactor)],
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
                      if (val != null) _cubit.updateScaleFactor(val);
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
                      final val = (e.target as dynamic).checked == true;
                      _cubit.updateAddTriangleGradients(val);
                    },
                  },
                ),
                const label(
                  classes: "form-check-label ms-2 fw-medium",
                  attributes: {"for": "checkGradients"},
                  [Component.text(AppStrings.addTriangleGradients)],
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
                      final val = (e.target as dynamic).checked == true;
                      _cubit.updateAnnotateWithDimensions(val);
                    },
                  },
                ),
                const label(
                  classes: "form-check-label ms-2 fw-medium",
                  attributes: {"for": "checkAnnotate"},
                  [Component.text(AppStrings.annotateWithDimensions)],
                ),
              ]),
            ]),
          ],
        );
      },
    );
  }
}
