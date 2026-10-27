# Triangles Embedding & Theming Guide

This guide explains how to embed Triangles screens and views into another Flutter or Web (Jaspr) project with custom themes, custom layouts, and shared router integration (`go_router` for Flutter, `jaspr_router` for Web), as well as sub-tree embedding using the `willshex_embedding` framework.

---

## 1. Flutter Integration (`client_flutter`)

### 1.1 Add Dependency

In the host project's `pubspec.yaml`:

```yaml
dependencies:
  client_flutter:
    path: ../willshex_triangles/packages/client_flutter
  client_common:
    path: ../willshex_triangles/packages/client_common
  go_router: ^11.1.4 # or host version
```

### 1.2 Mounting Routes into Host's `GoRouter`

`TrianglesRoutes.routes` returns a `List<RouteBase>` configured for your host application. It provides complete control over prefixes, subroutes, and individual route paths.

#### Option A: Mounting Under a URL Prefix (Top-level Routes)
```dart
import 'package:client_flutter/client_flutter.dart';
import 'package:go_router/go_router.dart';

final GoRouter hostRouter = GoRouter(
  initialLocation: '/triangles/welcome',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HostHomeScreen(),
    ),

    // Mount all Triangles routes prefixed with '/triangles'
    ...TrianglesRoutes.routes(
      prefix: '/triangles', // Routes: /triangles/welcome, /triangles/palettepicker, etc.
      showDrawer: false,    // Use host navigation instead of internal drawer
      showAppBar: true,     // Keep page AppBar (or false if host shell provides it)
    ),
  ],
);
```

#### Option B: Mounting as Child Subroutes Under a Parent `GoRoute`
In `go_router`, child routes mounted under a parent route must have relative paths (no leading `/`). Set `relative: true`:

```dart
GoRoute(
  path: '/triangles',
  builder: (context, state) => const TrianglesHostShell(),
  routes: [
    // Generates relative paths ("welcome", "palettepicker") for GoRouter,
    // while internal links/drawer properly navigate to "/triangles/welcome".
    ...TrianglesRoutes.routes(
      prefix: '/triangles',
      relative: true,
      showDrawer: false,
    ),
  ],
)
```

#### Option C: Overriding Individual Paths
You can override any or all route paths individually using `TrianglesRoutePaths`:

```dart
...TrianglesRoutes.routes(
  paths: const TrianglesRoutePaths(
    welcome: '/intro',
    palettePicker: '/generator',
    settings: '/preferences',
  ),
  showDrawer: false,
)
```

You can also combine individual overrides with a prefix:

```dart
...TrianglesRoutes.routes(
  paths: TrianglesRoutePaths.withPrefix(
    '/triangles',
    welcome: '/triangles/start',
    palettePicker: '/triangles/editor',
  ),
  showDrawer: false,
)
```

#### Option D: Cherry-picking Individual Routes
If you only need specific Triangles screens, mount them individually using the dedicated route factories:

```dart
routes: [
  TrianglesRoutes.palettePickerRoute(
    path: '/create-triangles',
    showDrawer: false,
    showAppBar: true,
  ),
  TrianglesRoutes.settingsRoute(
    path: '/custom-settings',
    showDrawer: false,
    showAppBar: true,
  ),
]
```

### 1.3 Embed Pure Views Directly (Without Routing or Scaffolds)

If your host project already has its own tabs, bottom navigation, or page scaffolds, embed the pure views directly:

```dart
import 'package:flutter/material.dart';
import 'package:client_common/client_common.dart';
import 'package:client_flutter/client_flutter.dart';

class MyCustomHostScreen extends StatelessWidget {
  const MyCustomHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: const TriangleGeneratorView(
        title: AppStrings.navPalettePicker,
        generatorType: GeneratorType.palettePicker,
        showDownloadFab: true,
        showHistoryInControls: true, // History accessible directly inside controls bar
      ),
    );
  }
}
```

Available pure views in `client_flutter`:
- `WelcomeView`: Combined home view featuring introductory cards, sample gallery, project information, credits, and legal notice.
- `TriangleGeneratorView`: Generator controls, canvas viewport, and history drawer/sheet.
- `SettingsView`: Width, height, ratio, and gradient settings.
- `AboutView`: Embeddable card with project information, open-source credits, and legal notice (also included directly inside `WelcomeView`).

### 1.4 Custom Theming in Flutter

All Triangles Flutter views strictly inherit from the active `Theme.of(context)`. They automatically adapt to your host app's:
- Material 3 `ColorScheme` (primary, surfaceContainer, outline, etc.)
- Typography (`textTheme`)
- Light / Dark brightness

Example host theme:

```dart
MaterialApp.router(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal, // Custom host color
      brightness: Brightness.dark,
    ),
  ),
  routerConfig: hostRouter,
);
```

### 1.5 State & Cubit Resolution

If your host project does not provide `SettingsCubit` in the widget tree, `TriangleGeneratorView` and `SettingsView` will automatically instantiate an internal fallback `SettingsCubit` with default in-memory or preferences storage.

To share settings across your host application:

```dart
BlocProvider<SettingsCubit>(
  create: (context) => SettingsCubit(PreferencesSettingsStorage(sharedPreferences)),
  child: MaterialApp.router(...),
);
```

---

## 2. Web Integration (`client_web` / Jaspr)

### 2.1 Add Dependency

In the host project's `pubspec.yaml`:

```yaml
dependencies:
  client_web:
    path: ../willshex_triangles/packages/client_web
  client_common:
    path: ../willshex_triangles/packages/client_common
  jaspr: ^0.23.4
  jaspr_router: ^0.9.0
```

### 2.2 Include Stylesheet

In your host web project's HTML `<head>` (e.g. `index.html`):

```html
<!-- Bootstrap 5 & Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- Triangles stylesheet -->
<link rel="stylesheet" href="packages/client_web/styles.css">
```

### 2.3 Mount Routes into Host's `jaspr_router`

`TrianglesWebRoutes.routes` returns a `List<Route>` compatible with `jaspr_router`:

#### Option A: Embedded in Host Shell with Subpath Prefix
```dart
import 'package:client_web/client_web.dart';
import 'package:jaspr_router/jaspr_router.dart';

final router = Router(
  routes: [
    ShellRoute(
      builder: (context, state, child) => MyHostAppShell(child: child),
      routes: [
        // Mount Triangles routes under '/triangles' without standalone AppLayout
        ...TrianglesWebRoutes.routes(
          prefix: '/triangles',
          useLayout: false, // Pure content views without Triangles sidebar/topbar
        ),
      ],
    ),
  ],
);
```

#### Option B: Standalone Triangles Layout with Prefix
```dart
final router = Router(
  routes: [
    ...TrianglesWebRoutes.routes(
      prefix: '/triangles',
      useLayout: true, // Includes full sidebar and topbar updated to '/triangles'
    ),
  ],
);
```

#### Option C: Overriding Individual Web Route Paths
```dart
...TrianglesWebRoutes.routes(
  paths: const TrianglesRoutePaths(
    welcome: '/start',
    palettePicker: '/editor',
    settings: '/preferences',
  ),
  useLayout: false,
)
```

#### Option D: Cherry-picking Individual Routes
```dart
routes: [
  TrianglesWebRoutes.palettePickerRoute(
    path: '/custom-picker',
    useLayout: false,
  ),
  TrianglesWebRoutes.welcomeRoute(
    path: '/intro',
    useLayout: false,
  ),
]
```

### 2.4 Embed Pure Views in Host Components

You can also use pure web views directly inside any Jaspr component:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:client_web/client_web.dart';
import 'package:client_common/client_common.dart';

class MyHostComponent extends StatelessComponent {
  const MyHostComponent({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: "my-container", [
      const TriangleGeneratorView(
        generatorType: GeneratorType.palettePicker,
      ),
    ]);
  }
}
```

Available pure views in `client_web`:
- `WelcomeView`: Combined home view featuring intro headline, sample showcase, quick-start guide, project credits, and legal notice.
- `TriangleGeneratorView`: Canvas viewport with reactive controls.
- `SettingsView`: Generator dimensions, scaling, and gradient options.
- `AboutView`: Embeddable card with project information, open-source credits, and legal notice (also included directly inside `WelcomeView`).

### 2.5 Custom Theming in Web

Triangles web styles integrate directly with Bootstrap 5 theme tokens and CSS custom properties:

1. **Bootstrap 5 Theme Token Inheritance**:
   - `data-bs-theme="dark"` or `data-bs-theme="light"` on `<html>` or any parent container controls dark/light mode.
   - Primary color inherits from `--bs-primary`.
   - Backgrounds inherit from `--bs-body-bg` and `--bs-card-bg`.

2. **Custom CSS Variable Overrides**:
   You can override theme variables at the root or scoped to a container:

```css
.my-custom-theme {
  --primary-color: #059669; /* Custom emerald */
  --bg-color: #111827;
  --card-bg: #1f2937;
  --border-color: #374151;
  --text-main: #f9fafb;
}
```

---

## 3. Integration with `willshex_embedding` Framework

When embedding `willshex_triangles` into a host orchestrated by the [`willshex_embedding`](https://github.com/billy1380/willshex_embedding) framework (such as `flutter-willshex`), visual chrome (sidebar navigation, top header, breadcrumbs, contextual action toolbars, and secondary panels) is completely delegated to the host shell.

### 3.1 Sub-Tree Outline Mounting

`packages/client_common` exposes `configureTrianglesOutline`, which registers the entire Triangles navigation outline onto an `EmbeddingHostController`.

Titles are clean human-readable strings defined in [`AppStrings`](../packages/client_common/lib/constants/app_strings.dart) without numeric or index prefixes (coordinates are determined purely by `IndexKey`).

Hosts can mount the Triangles sub-tree under any desired parent `IndexKey`:

```dart
import 'package:client_common/outline_setup.dart';
import 'package:willshex_embedding/willshex_embedding.dart';

void setupNavigation(EmbeddingHostController controller) {
  // Mount Triangles outline under '1.2.5' (e.g. Software > Experiments > Triangles):
  configureTrianglesOutline(
    controller,
    parentIndex: const IndexKey([1, 2, 5]),
    paths: TrianglesRoutePaths.withPrefix('/experiments/triangles'),
  );
}
```

#### Resulting Navigation Hierarchy in Host:
- `1` Software
  - `1.2` Experiments
    - `1.2.5` Triangles
      - `1.2.5.0` **Welcome**
      - `1.2.5.1` **Palette Types** (Category node)
        - `1.2.5.1.1` **Palette Picker**
        - `1.2.5.1.2` **HTML Colours**
        - `1.2.5.1.3` **Random Palette**
        - `1.2.5.1.4` **Random Grayscale**
        - `1.2.5.1.5` **Image Palette**
        - `1.2.5.1.6` **Image Sampler**
      - `1.2.5.2` **Settings**

### 3.2 Viewport Content Mapping & Page Sessions

In the host's `EmbeddingViewport`, register the Triangles view builders. Pass the `session` parameter provided by the viewport to `TriangleGeneratorView` to connect the view to the host's outer chrome:

#### In Flutter:
```dart
EmbeddingViewport(
  pageSlots: {
    paths.welcome: (context, session) => const WelcomeView(),
    paths.palettePicker: (context, session) => TriangleGeneratorView(
      title: AppStrings.navPalettePicker,
      generatorType: GeneratorType.palettePicker,
      showDownloadFab: false, // Actions promoted to host toolbar
      session: session,
    ),
    paths.htmlColour: (context, session) => TriangleGeneratorView(
      title: AppStrings.navHtmlColours,
      generatorType: GeneratorType.htmlColour,
      showDownloadFab: false,
      session: session,
    ),
    paths.randomPalette: (context, session) => TriangleGeneratorView(
      title: AppStrings.navRandomPalette,
      generatorType: GeneratorType.randomPalette,
      showDownloadFab: false,
      session: session,
    ),
    paths.randomGrayscale: (context, session) => TriangleGeneratorView(
      title: AppStrings.navRandomGrayscale,
      generatorType: GeneratorType.randomGrayscale,
      showDownloadFab: false,
      session: session,
    ),
    paths.imagePalette: (context, session) => TriangleGeneratorView(
      title: AppStrings.imagePalette,
      generatorType: GeneratorType.imagePalette,
      showDownloadFab: false,
      session: session,
    ),
    paths.imageSampler: (context, session) => TriangleGeneratorView(
      title: AppStrings.navImageSampler,
      generatorType: GeneratorType.imageSampler,
      showDownloadFab: false,
      session: session,
    ),
    paths.settings: (context, session) => const SettingsView(),
  },
)
```

#### In Jaspr Web:
```dart
EmbeddingViewport(
  pageSlots: {
    paths.welcome: (context, session) => const WelcomeView(),
    paths.palettePicker: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.palettePicker,
      session: session,
    ),
    paths.htmlColour: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.htmlColour,
      session: session,
    ),
    paths.randomPalette: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.randomPalette,
      session: session,
    ),
    paths.randomGrayscale: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.randomGrayscale,
      session: session,
    ),
    paths.imagePalette: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.imagePalette,
      session: session,
    ),
    paths.imageSampler: (context, session) => TriangleGeneratorView(
      generatorType: GeneratorType.imageSampler,
      session: session,
    ),
    paths.settings: (context, session) => const SettingsView(),
  },
)
```

### 3.3 Contextual Action Promotion to Host Toolbar

When `session` is supplied, `TriangleGeneratorView` publishes its generator controls directly to the active `PageSession` instead of rendering inline buttons:

- **Generate** (`AppStrings.actionGenerate`, `ActionVariant.primary`, icon: `refresh`)
- **Pick Palette** (`AppStrings.actionPickPalette`, `ActionVariant.standard`, icon: `palette`)
- **Save Image** (`AppStrings.actionSaveImage`, `ActionVariant.outline`, icon: `download`)
- **Reset Zoom** (`AppStrings.actionResetZoom`, `ActionVariant.standard`)

The host shell renders these actions in its top `AppBar` (in Flutter) or header navbar (in Jaspr Web), matching host styling.

### 3.4 Secondary Named Area (`triangle_history`)

`TriangleGeneratorView` contributes generated palette history to the named area `AppStrings.areaTriangleHistory` (`'triangle_history'`). 

Hosts can mount an `EmbeddingAreaSlot` inside an inspector panel or drawer to display palette history with automatic collapsing when empty:

```dart
EmbeddingAreaSlot(
  areaName: AppStrings.areaTriangleHistory,
  containerClass: 'app-inspector-panel', // In Jaspr Web
)
```

When a user selects a palette in the history slot, the active generator restores it automatically.
