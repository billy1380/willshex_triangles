import "package:willshex_draw/willshex_draw.dart";
import "triangles_type.dart";
import "triangle_tiles.dart";
import "triangle_random_jiggle_tiles.dart";
import "triangle_ribbons.dart";
import "triangle_h_tiles.dart";
import "triangle_square_tiles.dart";
import "triangle_diamond_tiles.dart";
import "triangle_tiles_over_image.dart";

/// Factory for creating triangle generator instances
class TriangleFactory {
  static dynamic create(
    TrianglesType type,
    Renderer renderer,
    Palette palette,
    Rect bounds, {
    int? count,
    double? ratio,
  }) {
    switch (type) {
      case TrianglesType.diamondTiles:
        return ratio != null
            ? TriangleDiamondTiles.withRatio(renderer, palette, bounds, ratio)
            : TriangleDiamondTiles(renderer, palette, bounds);
      case TrianglesType.hTiles:
        return ratio != null
            ? TriangleHTiles.withRatio(renderer, palette, bounds, ratio)
            : TriangleHTiles(renderer, palette, bounds);
      case TrianglesType.randomJiggle:
        return ratio != null
            ? TriangleRandomJiggleTiles.withRatio(
                renderer, palette, bounds, ratio)
            : TriangleRandomJiggleTiles(renderer, palette, bounds);
      case TrianglesType.ribbons:
        if (count == null) {
          throw ArgumentError("TriangleRibbons requires a count parameter");
        }
        return ratio != null
            ? TriangleRibbons.withRatio(renderer, palette, bounds, count, ratio)
            : TriangleRibbons(renderer, palette, bounds, count);
      case TrianglesType.squareTiles:
        return ratio != null
            ? TriangleSquareTiles.withRatio(renderer, palette, bounds, ratio)
            : TriangleSquareTiles(renderer, palette, bounds);
      case TrianglesType.tiles:
        return ratio != null
            ? TriangleTiles.withRatio(renderer, palette, bounds, ratio)
            : TriangleTiles(renderer, palette, bounds);
      case TrianglesType.overImage:
        return ratio != null
            ? TriangleTilesOverImage.withRatio(renderer, palette, bounds, ratio)
            : TriangleTilesOverImage(renderer, palette, bounds);
      // Add more cases as needed for other types
      default:
        throw ArgumentError("Unsupported TrianglesType: $type");
    }
  }
}
