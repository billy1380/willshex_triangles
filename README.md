# willshex_triangles

Algorithmic low-poly and Delaunay-triangulated wallpaper and background generator built with Dart and Flutter.

`willshex_triangles` creates dynamic, aesthetically pleasing geometric mesh patterns, color gradients, and textures. Originally ported from the `willshex-triangles` Java engine, it is structured as a multi-package Dart workspace supporting Flutter (mobile, desktop, and web), Jaspr (lightweight client-side web), command-line batch generation (CLI), and modular embedding into host applications such as `flutter-willshex`.

---

## Features

- **Triangulation Engine**: Generates Delaunay meshes, grid perturbations, and custom low-poly structures (e.g., *Random Jiggle*, *N45 Degree Fabric*).
- **Color Palette Providers**:
  - **HTML Colours**: Curated web color schemes and named tones.
  - **Palette Picker**: Interactive palette designer with custom primary/secondary color sets.
  - **Random Palettes**: Procedurally generated vibrant harmonies and monochrome grayscale tones.
  - **Image Extraction & Sampling**: Derives harmonious color palettes directly from uploaded or sampled images.
- **Interactive Canvas & Controls**:
  - Pan and pinch-to-zoom with uniform z-axis scaling.
  - Reset zoom and responsive canvas viewport adapting to screen dimensions.
  - Palette history tracking with instant restoration.
- **Multi-Platform Support**:
  - **Flutter** application with Material 3 styling and responsive navigation.
  - **Jaspr Web** client rendering to HTML5 Canvas with Bootstrap styles.
  - **CLI** tool for batch image rendering and terminal automation.
- **Host Embedding & Extensibility**:
  - Pluggable route mounting for `go_router` (Flutter) and `jaspr_router` (Web).
  - First-class support for `willshex_embedding` host shells, including hierarchical outline registration, contextual action toolbars, and secondary named areas (`triangle_history`).

---

## Workspace Packages

The repository is organized as a Dart workspace containing the following packages:

| Package | Path | Description |
|---|---|---|
| **`client_common`** | [`packages/client_common`](packages/client_common) | Shared domain models, triangulation algorithms, palette providers, state management (`TriangleGeneratorCubit`, `SettingsCubit`), and embedding outline setup (`configureTrianglesOutline`). |
| **`client_flutter`** | [`packages/client_flutter`](packages/client_flutter) | Flutter application and reusable widget views (`TriangleGeneratorView`, `TriangleCanvas`, zoom/pan controls, palette pickers, `AppDrawer`). |
| **`client_web`** | [`packages/client_web`](packages/client_web) | Lightweight web client built using [Jaspr](https://docs.page/schultek/jaspr), providing HTML5 Canvas rendering and Bootstrap-based UI. |
| **`client_cli`** | [`packages/client_cli`](packages/client_cli) | Headless command-line tool for generating triangle images directly from terminal commands or shell scripts. |
| **`willshex_draw`** | [`packages/willshex_draw`](packages/willshex_draw) | Low-level geometry, Delaunay triangulation math, point distribution algorithms, and rendering utilities. |
| **`subtle_backgrounds`** | [`packages/subtle_backgrounds`](packages/subtle_backgrounds) | Bundled background textures and subtle pattern assets. |

---

## Getting Started

### Prerequisites

- **Dart SDK**: `>=3.5.0 <4.0.0`
- **Flutter SDK**: `>=3.47.0` (for `client_flutter`)

### Setup Dependencies

Resolve dependencies across all workspace packages from the root directory:

```bash
dart pub get
```

---

## Running Applications

### 1. Flutter Client (`client_flutter`)

Run the Flutter client on your target platform (macOS, Web, iOS, Android, Linux, Windows):

```bash
cd packages/client_flutter
flutter run
```

### 2. Jaspr Web Client (`client_web`)

Run the Jaspr development server with hot-reload:

```bash
cd packages/client_web
dart run jaspr:jaspr serve
```

### 3. Command-Line Interface (`client_cli`)

Generate an image directly from the command line using configuration parameters:

```bash
cd packages/client_cli
dart run bin/triangles.dart "w=1920&h=1080&u=N45DegreeFabric&t=RandomJiggle&rd=69&rn=11&p=Random&a=1"
```

The output file will be saved in the `output/` directory (e.g., `output/genimg_0.png`).

---

## Embedding into Host Applications

`willshex_triangles` is designed to be easily embedded as a feature module within host applications (such as `flutter-willshex`).

### Using `willshex_embedding`

When embedding into an application orchestrated by `willshex_embedding`, use `configureTrianglesOutline()` from `package:client_common/outline_setup.dart`:

```dart
import 'package:client_common/outline_setup.dart';
import 'package:willshex_embedding/willshex_embedding.dart';

void setupNavigation(EmbeddingHostController controller) {
  // Mount Triangles outline under a parent node (e.g., "1.2.5 Triangles")
  configureTrianglesOutline(
    controller,
    parentIndex: IndexKey([1, 2, 5]),
  );
}
```

The embedded views automatically publish:
- **Dynamic Titles**: Reflecting the active generator mode.
- **Contextual Actions**: `Generate`, `Pick Palette`, `Save Image`, and `Reset Zoom` are mounted directly into the host toolbar via `PageSession`.
- **Secondary Named Area (`triangle_history`)**: Publishes recent palette history items that can be restored with a single click.

### Using Standard Routing

- **Flutter (`go_router`)**: Mount routes with `TrianglesRoutes.routes(prefix: '/triangles', showDrawer: false)`.
- **Jaspr (`jaspr_router`)**: Mount routes with `TrianglesRoutes.routes(prefix: '/triangles')`.

For detailed embedding examples, router mounting options, and custom theming, see [docs/EMBEDDING_GUIDE.md](docs/EMBEDDING_GUIDE.md).

---

## Coding Conventions & Guidelines

### Centralized Strings (`AppStrings`)

To avoid regressions, ensure consistent branding, and keep UI code decoupled from copy:
- **Do not hardcode user-facing strings or action labels in UI widgets or outlines.**
- All user-facing strings (navigation titles, menu entries, contextual action labels, tooltips, dialogs, error messages, and secondary navigation area identifiers) **must** be declared as static constants in [`AppStrings`](packages/client_common/lib/constants/app_strings.dart) within `client_common`.

---

## Configuration Parameter Reference

When using `client_cli` or configuring image generation parameters, the following keys are available:

| Key | Name | Description | Default |
|---|---|---|---|
| `w` | Width | Width of the generated image in pixels. | `300` |
| `h` | Height | Height of the generated image in pixels. | `300` |
| `f` | Format | Image format output (`png`, etc.). | `png` |
| `t` | Type | Triangulation mesh algorithm (`RandomJiggle`, etc.). | `RandomJiggle` |
| `u` | Texture | Background texture name (e.g. `N45DegreeFabric`). | `null` |
| `p` | Palette | Palette provider (`RandomNamed`, `RandomColour`, `HtmlColours`, etc.). | `RandomNamed` |
| `pc` | Palette Colours | Custom colors passed to the palette generator. | `null` |
| `rd` | Ratio Denominator | Grid denominator scaling ratio. | `12` |
| `rn` | Ratio Numerator | Grid numerator scaling ratio. | `1` |
| `c` | Composite | Blend mode for texture overlay (`colorBurn`, etc.). | `colorBurn` |
| `a` | Annotate | Whether to annotate points/triangles (`0` = off, `1` = on). | `0` |

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
