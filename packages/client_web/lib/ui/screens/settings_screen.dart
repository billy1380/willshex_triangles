import "package:willshex_embedding/willshex_embedding.dart";
import "package:web/web.dart" as web;
import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_web/ui/bloc_provider.dart";
import "package:triangles_web/ui/layout.dart";

import "package:triangles_web/services/local_storage_settings_storage.dart";

/// Shared settings provider for Web.
class TrianglesWebSettings {
  TrianglesWebSettings._();
  static SettingsCubit? _cubit;
  static SettingsCubit get cubit =>
      _cubit ??= SettingsCubit(LocalStorageSettingsStorage());

  static void useStorage(SettingsStore storage) {
    _cubit = SettingsCubit(EmbeddingSettingsAdapter(storage));
  }
}

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
  late final SettingsCubit _cubit;
  ThemeCubit? _themeCubit;

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
        _cubit = TrianglesWebSettings.cubit;
      }
    }
    _themeCubit = BlocProvider.maybeOf<ThemeCubit>(context);
  }

  Component _themeSelect(ThemeCubit cubit) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      bloc: cubit,
      builder: (context, current) => div(classes: "mt-3", [
        const label(
          classes: "form-label text-secondary small fw-bold d-block",
          [Component.text(AppStrings.theme)],
        ),
        select(
          classes: "form-select",
          events: {
            "change": (e) {
              final val = (e.target as dynamic).value as String;
              final mode = AppThemeMode.fromName(val);
              cubit.setMode(mode);
            },
          },
          [
            for (final mode in AppThemeMode.values)
              option(
                value: mode.name,
                selected: mode == current,
                [Component.text(mode.label)],
              ),
          ],
        ),
      ]),
    );
  }

  @override
  void dispose() {
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
                        final target = e.target as web.HTMLInputElement;
                        final val = int.tryParse(target.value);
                        if (val != null) _cubit.updateWidth(val);
                      },
                      "change": (e) {
                        final target = e.target as web.HTMLInputElement;
                        final val = int.tryParse(target.value);
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
                        final target = e.target as web.HTMLInputElement;
                        final val = int.tryParse(target.value);
                        if (val != null) _cubit.updateHeight(val);
                      },
                      "change": (e) {
                        final target = e.target as web.HTMLInputElement;
                        final val = int.tryParse(target.value);
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
                      final target = e.target as web.HTMLInputElement;
                      final val = double.tryParse(target.value);
                      if (val != null) _cubit.updateScaleFactor(val);
                    },
                    "change": (e) {
                      final target = e.target as web.HTMLInputElement;
                      final val = double.tryParse(target.value);
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
                      final target = e.target as web.HTMLInputElement;
                      _cubit.updateAddTriangleGradients(target.checked);
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
                      final target = e.target as web.HTMLInputElement;
                      _cubit.updateAnnotateWithDimensions(target.checked);
                    },
                  },
                ),
                const label(
                  classes: "form-check-label ms-2 fw-medium",
                  attributes: {"for": "checkAnnotate"},
                  [Component.text(AppStrings.annotateWithDimensions)],
                ),
              ]),
              if (_themeCubit != null) ...[
                const hr(),
                _themeSelect(_themeCubit!),
              ],
            ]),
          ],
        );
      },
    );
  }
}
