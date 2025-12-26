/// Shared triangle generation engine for willshex-triangles
library willshex_triangles_shared;

// Core types and configuration
export "triangles_type.dart";
export "image_generator_config.dart";
export "store.dart";

// Triangle generation classes
export "triangle_tiles.dart";
export "triangle_random_jiggle_tiles.dart";
export "triangle_ribbons.dart";
export "triangle_h_tiles.dart";
export "triangle_square_tiles.dart";
export "triangle_diamond_tiles.dart";

// Helper classes
export "helper/drawing_helper.dart";

// Graphics utilities for color analysis and palette extraction
export "graphics/graphics.dart";

// Server components (moved to triangles)
export "image_generator.dart";
export "string_drawer.dart";
export "image_renderer.dart";

// Desktop components
export "../desktop/triangles.dart";
export "../desktop/store/file_store.dart";
export "graphics/random_color_palette.dart";
export "triangle_factory.dart";
