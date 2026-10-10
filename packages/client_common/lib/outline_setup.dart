import "package:willshex_embedding/willshex_embedding.dart";
import "constants/app_strings.dart";
import "models/triangles_route_paths.dart";

/// Configures the Triangles navigation outline on the given [controller].
///
/// Titles are clean display strings without numeric or index prefixes.
/// If [parentIndex] is provided, nodes are mounted as children of that index.
/// If [paths] is supplied, custom route paths/prefixes are respected.
void configureTrianglesOutline(
  EmbeddingController controller, {
  IndexKey? parentIndex,
  TrianglesRoutePaths paths = const TrianglesRoutePaths(),
  bool includeWelcome = true,
}) {
  IndexKey makeKey(List<int> segments) {
    if (parentIndex == null) return IndexKey(segments);
    return IndexKey([...parentIndex.segments, ...segments]);
  }

  // Welcome (index [0])
  if (includeWelcome) {
    controller.registerNavNode(
      NavNode(
        index: makeKey([0]),
        title: AppStrings.navWelcome,
        icon: const EmbeddingIcon.named("home"),
        targetPageId: paths.welcome,
      ),
    );
  }

  // Palette Types (index [1]) - Category
  final palettesKey = makeKey([1]);
  controller.registerNavNode(
    NavNode(
      index: palettesKey,
      title: AppStrings.navPaletteTypes,
      icon: const EmbeddingIcon.named("palette"),
    ),
  );

  // Palette Picker (index [1, 1])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 1]),
      title: AppStrings.navPalettePicker,
      icon: const EmbeddingIcon.named("colorize"),
      targetPageId: paths.palettePicker,
    ),
  );

  // HTML Colours (index [1, 2])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 2]),
      title: AppStrings.navHtmlColours,
      icon: const EmbeddingIcon.named("code"),
      targetPageId: paths.htmlColour,
    ),
  );

  // Random Palette (index [1, 3])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 3]),
      title: AppStrings.navRandomPalette,
      icon: const EmbeddingIcon.named("shuffle"),
      targetPageId: paths.randomPalette,
    ),
  );

  // Random Grayscale (index [1, 4])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 4]),
      title: AppStrings.navRandomGrayscale,
      icon: const EmbeddingIcon.named("contrast"),
      targetPageId: paths.randomGrayscale,
    ),
  );

  // Image Palette (index [1, 5])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 5]),
      title: AppStrings.imagePalette,
      icon: const EmbeddingIcon.named("image"),
      targetPageId: paths.imagePalette,
    ),
  );

  // Image Sampler (index [1, 6])
  controller.registerNavNode(
    NavNode(
      index: makeKey([1, 6]),
      title: AppStrings.navImageSampler,
      icon: const EmbeddingIcon.named("palette"),
      targetPageId: paths.imageSampler,
    ),
  );

  // Settings (index [2])
  controller.registerNavNode(
    NavNode(
      index: makeKey([2]),
      title: AppStrings.navSettings,
      icon: const EmbeddingIcon.named("settings"),
      targetPageId: paths.settings,
    ),
  );
}
