# Product Requirements Document (PRD)
## `willshex_triangles` — `willshex_embedding` Integration

---

## 1. Executive Summary & Goals

This document outlines the architectural plan and implementation steps for modernizing `willshex_triangles` to adopt the [`willshex_embedding`](https://github.com/billy1380/willshex_embedding) framework.

The primary goals are:
1. **Unify Primary Navigation**: Replace the standalone `AppDrawer` with an outline hierarchy driven by `EmbeddingHostController` and `NavNode`.
2. **Clean Titles without Index Prefixes**: Menu item titles must be clean human-readable names (e.g. `"Welcome"`, `"Palette Picker"`, `"Settings"`) with **no numeric or index prefixes** in the label strings; outline coordinates are represented exclusively via `IndexKey`.
3. **Contextual Action Delegation**: Modernize `TriangleGeneratorView` to publish generator actions (`Generate`, `Pick Palette`, `Save Image`, `Reset Zoom`) via `PageSession.setActions()`.
4. **Secondary Area for History**: Expose palette history through the named area `'triangle_history'`.
5. **Standalone Shell & Pure View Parity**: Support running `willshex_triangles` as a standalone application shell in Flutter and Jaspr Web, while keeping views decoupled for external embedding.

---

## 2. Navigation Outline & Data Model

### 2.1 Outline Hierarchy

The outline is defined in `packages/client_common/lib/outline_setup.dart`. All menu titles are clean strings without index prefixes:

| IndexKey | Title | Target Page ID / Route | Icon |
| :--- | :--- | :--- | :--- |
| `[0]` | `"Welcome"` | `/welcome` | `home` |
| `[1]` | `"Palette Types"` | *(Category node, no direct page)* | `palette` |
| `[1, 1]` | `"Palette Picker"` | `/palettepicker` | `colorize` |
| `[1, 2]` | `"HTML Colours"` | `/htmlcolour` | `code` |
| `[1, 3]` | `"Random Palette"` | `/random-palette` | `shuffle` |
| `[1, 4]` | `"Random Grayscale"` | `/random-grayscale-palette` | `contrast` |
| `[1, 5]` | `"Image Palette"` | `/imagepalette` | `image` |
| `[1, 6]` | `"Image Sampler"` | `/imagesamplerpalette` | `palette` |
| `[2]` | `"Settings"` | `/settings` | `settings` |

> **Note**: Item titles must **never** include hardcoded index numbers (e.g. use `"Welcome"`, not `"0 Welcome"` or `"0. Welcome"`). Dotted-decimal coordinates are handled exclusively by `IndexKey`.

### 2.2 Named Areas

- **`'triangle_history'`**: A secondary area for recently generated or sampled palettes.
  - Layout hint: `AreaLayoutHint.custom` / list.
  - Automatically collapses when no history exists.

### 2.3 Contextual Page Actions

Active generator screens publish the following actions to the host shell:

| Action ID | Label | Variant | Order | Callback |
| :--- | :--- | :--- | :--- | :--- |
| `'generate'` | `"Generate"` | `ActionVariant.primary` | `1` | `cubit.generate()` |
| `'pick_palette'` | `"Pick Palette"` | `ActionVariant.standard` | `2` | `openCustomPalettePicker()` |
| `'download'` | `"Save Image"` | `ActionVariant.outline` | `3` | `saveImage()` |
| `'reset_zoom'` | `"Reset Zoom"` | `ActionVariant.standard` | `4` | `resetZoom()` |

---

## 3. Package Implementation Tasks

### Task 1: Add Dependencies
- **`packages/client_common/pubspec.yaml`**:
  ```yaml
  dependencies:
    willshex_embedding:
      path: ../../../willshex_embedding
  ```
- Ensure `client_flutter` and `client_web` have access to `willshex_embedding` via `client_common`.

### Task 2: Create `outline_setup.dart` in `client_common`
Create `packages/client_common/lib/outline_setup.dart` exporting `configureTrianglesOutline(EmbeddingHostController controller, {IndexKey? parentIndex, TrianglesRoutePaths paths})`.

### Task 3: Contextual Actions in `client_flutter`
Update `TriangleGeneratorView` in `packages/client_flutter/lib/parts/triangle_generator_page.dart`:
- Accept optional `PageSession? session`.
- When mounted, call `session.setActions(...)`.
- Publish palette history to `session.setAreaItems('triangle_history', ...)`.

### Task 4: Standalone Shell in `client_flutter`
Update `packages/client_flutter/lib/routes.dart`:
- Wrap standalone routes with `EmbeddingHostScope` and root `ShellRoute`.
- Replace standalone `AppDrawer` with `EmbeddingHierarchicalNav`.
- Render dynamic `AppBar` with `EmbeddingPageActionsBar`.

### Task 5: Standalone Shell in `client_web`
Update `packages/client_web/lib/ui/layout.dart`:
- Replace custom sidebar list with `EmbeddingHierarchicalNav`.
- Header renders `EmbeddingPageActions` and `EmbeddingPageTitle`.

---

## 4. Acceptance Criteria & Completion

1. `willshex_triangles` runs in standalone mode in both Flutter and Jaspr Web using `DefaultEmbeddingController`.
2. Nav menu displays clean titles without numeric prefixes.
3. Generator controls appear in the host action bar when navigating between palette types.
4. History updates appear in the `'triangle_history'` slot.
5. Once implementation is verified and approved, this PRD document can be removed.
