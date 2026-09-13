import "package:jaspr/dom.dart";
import "package:jaspr/jaspr.dart";
import "package:jaspr_router/jaspr_router.dart";
import "package:web/web.dart" as web;
import "package:client_common/client_common.dart";

class AppLayout extends StatefulComponent {
  final String title;
  final List<Component> actions;
  final Component child;

  const AppLayout({
    required this.title,
    this.actions = const [],
    required this.child,
    super.key,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late bool _isDark =
      web.document.documentElement?.getAttribute("data-bs-theme") != "light";
  bool _sidebarOpen = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      web.document.documentElement
          ?.setAttribute("data-bs-theme", _isDark ? "dark" : "light");
    });
  }

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
    final isActive =
        currentPath == route || (route == "/welcome" && currentPath == "/");

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

  @override
  Component build(BuildContext context) {
    final currentPath = Router.of(context).matchList.uri.path;

    return div(classes: "app-container", [
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
              events: {"click": (e) => _toggleSidebar()},
              const [i(classes: "bi bi-x-lg", [])],
            ),
          ]),
          nav(classes: "sidebar-nav", [
            _navLink(
              label: AppStrings.navWelcome,
              route: "/welcome",
              icon: "bi-house",
              currentPath: currentPath,
            ),
            const div(classes: "nav-section-title mt-3", [
              Component.text(AppStrings.navTypes),
            ]),
            _navLink(
              label: AppStrings.navPalettePicker,
              route: "/palettepicker",
              icon: "bi-eyedropper",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navHtmlColour,
              route: "/htmlcolour",
              icon: "bi-palette2",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navRandomPalette,
              route: "/random-palette",
              icon: "bi-shuffle",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navRandomGrayscale,
              route: "/random-grayscale-palette",
              icon: "bi-circle-half",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.imagePalette,
              route: "/imagepalette",
              icon: "bi-image",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.imageSamplerPalette,
              route: "/imagesamplerpalette",
              icon: "bi-grid-3x3",
              currentPath: currentPath,
            ),
            const div(classes: "nav-section-title mt-3", [
              Component.text(AppStrings.navPreferences),
            ]),
            _navLink(
              label: AppStrings.navSettings,
              route: "/settings",
              icon: "bi-gear",
              currentPath: currentPath,
            ),
            _navLink(
              label: AppStrings.navAbout,
              route: "/about",
              icon: "bi-info-circle",
              currentPath: currentPath,
            ),
          ]),
          div(classes: "sidebar-footer", [
            button(
              classes: "btn btn-outline-secondary btn-sm w-100",
              events: {"click": (e) => _toggleTheme()},
              [
                i(
                  classes:
                      "bi ${_isDark ? 'bi-sun-fill' : 'bi-moon-stars-fill'} me-2",
                  const [],
                ),
                Component.text(_isDark ? AppStrings.lightMode : AppStrings.darkMode),
              ],
            ),
          ]),
        ],
      ),
      main_(classes: "app-main", [
        header(classes: "app-topbar", [
          div(classes: "d-flex align-items-center gap-3", [
            button(
              classes: "btn btn-sm btn-outline-secondary d-lg-none",
              events: {"click": (e) => _toggleSidebar()},
              const [i(classes: "bi bi-list fs-5", [])],
            ),
            h2(classes: "page-title", [Component.text(component.title)]),
          ]),
          div(classes: "app-topbar-actions", component.actions),
        ]),
        component.child,
      ]),
    ]);
  }
}
