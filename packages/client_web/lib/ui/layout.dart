import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:jaspr_router/jaspr_router.dart";
import "package:triangles_common/client_common.dart";
import "package:triangles_web/services/web_theme_applier.dart";
import "package:triangles_web/ui/bloc_provider.dart";

class AppLayout extends StatefulComponent {
  final String title;
  final List<Component> actions;
  final Component child;
  final TrianglesRoutePaths paths;
  final ThemeCubit? themeCubit;

  AppLayout({
    required this.title,
    this.actions = const [],
    required this.child,
    TrianglesRoutePaths? paths,
    String? basePath,
    this.themeCubit,
    super.key,
  }) : paths = paths ??
            (basePath != null && basePath.isNotEmpty
                ? TrianglesRoutePaths.withPrefix(basePath)
                : const TrianglesRoutePaths());

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  bool _sidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _sidebarOpen = !_sidebarOpen;
    });
  }

  Component _navLink({
    required String label,
    required String route,
    required String icon,
    required String currentPath,
  }) {
    final isActive = currentPath == route ||
        (route == component.paths.welcome &&
            (currentPath == route ||
                currentPath == "/" ||
                currentPath.isEmpty));

    return a(
      href: route,
      classes: "sidebar-link ${isActive ? 'active' : ''}",
      events: {
        "click": (e) {
          if (_sidebarOpen) {
            setState(() => _sidebarOpen = false);
          }
        },
      },
      [
        i(classes: "bi $icon", const []),
        span([Component.text(label)]),
      ],
    );
  }

  ThemeCubit? _resolveThemeCubit() {
    if (component.themeCubit != null) return component.themeCubit;
    return BlocProvider.maybeOf<ThemeCubit>(context);
  }

  static String _themeIcon(AppThemeMode mode) => switch (mode) {
        AppThemeMode.system => "bi-circle-half",
        AppThemeMode.light => "bi-sun",
        AppThemeMode.dark => "bi-moon-stars",
      };

  Component _sidebarThemeSelection(ThemeCubit cubit) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      bloc: cubit,
      builder: (context, current) => div(classes: "sidebar-footer", [
        button(
          classes: "sidebar-theme-toggle",
          attributes: {
            "type": "button",
            "title": "${AppStrings.theme}: ${current.label}",
            "aria-label": "${AppStrings.theme}: ${current.label}",
          },
          events: {
            "click": (e) => cubit.toggle(WebThemeApplier.isPlatformDark),
          },
          [
            i(classes: "bi ${_themeIcon(current)}", const []),
            span([Component.text("${AppStrings.theme}: ${current.label}")]),
          ],
        ),
      ]),
    );
  }

  @override
  Component build(BuildContext context) {
    final currentPath = Router.of(context).matchList.uri.path;
    final themeCubit = _resolveThemeCubit();

    return div(classes: "app-container has-sidebar", [
      if (_sidebarOpen)
        div(
          classes: "sidebar-backdrop",
          events: {"click": (e) => _toggleSidebar()},
          const [],
        ),
      aside(
        classes: "app-sidebar ${_sidebarOpen ? 'open' : ''}",
        [
          div(classes: "app-sidebar-header", [
            const h1(classes: "brand-title", [
              i(classes: "bi bi-triangle-half text-primary", []),
              Component.text(AppStrings.appName),
            ]),
            button(
              classes: "btn btn-sm btn-link d-lg-none text-secondary",
              attributes: const {
                "title": AppStrings.closeSidebar,
                "aria-label": AppStrings.closeSidebar,
              },
              events: {"click": (e) => _toggleSidebar()},
              const [i(classes: "bi bi-x-lg", [])],
            ),
          ]),
          nav(classes: "sidebar-nav", [
            _navLink(
              label: AppStrings.navWelcome,
              route: component.paths.welcome,
              icon: "bi-house",
              currentPath: currentPath,
            ),
            const div(classes: "nav-section-title mt-3", [
              Component.text(AppStrings.navTypes),
            ]),
            _navLink(
              label: AppStrings.navPalettePicker,
              route: component.paths.palettePicker,
              icon: "bi-eyedropper",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navHtmlColour,
              route: component.paths.htmlColour,
              icon: "bi-palette2",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navRandomPalette,
              route: component.paths.randomPalette,
              icon: "bi-shuffle",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navRandomGrayscale,
              route: component.paths.randomGrayscale,
              icon: "bi-circle-half",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.imagePalette,
              route: component.paths.imagePalette,
              icon: "bi-image",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.imageSamplerPalette,
              route: component.paths.imageSampler,
              icon: "bi-grid-3x3",
              currentPath: currentPath,
            ),
            const div(classes: "nav-section-title mt-3", [
              Component.text(AppStrings.navPreferences),
            ]),
            _navLink(
              label: AppStrings.navSettings,
              route: component.paths.settings,
              icon: "bi-gear",
              currentPath: currentPath,
            ),
          ]),
          if (themeCubit != null) _sidebarThemeSelection(themeCubit),
        ],
      ),
      main_(classes: "app-main", [
        header(
          classes:
              "navbar border-bottom px-4 py-2 sticky-top bg-body d-flex justify-content-between align-items-center",
          [
            div(classes: "d-flex align-items-center gap-3", [
              button(
                classes: "btn btn-sm btn-outline-secondary d-lg-none",
                attributes: const {
                  "title": AppStrings.toggleMenu,
                  "aria-label": AppStrings.toggleMenu,
                },
                events: {"click": (e) => _toggleSidebar()},
                const [i(classes: "bi bi-list fs-5", [])],
              ),
              h2(classes: "h5 m-0 fw-bold", [Component.text(component.title)]),
            ]),
            div(classes: "d-flex align-items-center gap-2", component.actions),
          ],
        ),
        component.child,
      ]),
    ]);
  }
}
