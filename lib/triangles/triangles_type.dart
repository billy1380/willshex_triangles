/// Triangle generation types for the willshex-triangles engine
enum TrianglesType {
  hTiles,
  randomJiggle,
  ribbons,
  squareTiles,
  diamondTiles,
  tiles;

  /// Convert enum to string for serialization
  String get name {
    switch (this) {
      case TrianglesType.hTiles:
        return "HTiles";
      case TrianglesType.randomJiggle:
        return "RandomJiggle";
      case TrianglesType.ribbons:
        return "Ribbons";
      case TrianglesType.squareTiles:
        return "SquareTiles";
      case TrianglesType.diamondTiles:
        return "DiamondTiles";
      case TrianglesType.tiles:
        return "Tiles";
    }
  }

  /// Parse string to enum
  static TrianglesType fromString(String name) {
    switch (name) {
      case "HTiles":
        return TrianglesType.hTiles;
      case "RandomJiggle":
        return TrianglesType.randomJiggle;
      case "Ribbons":
        return TrianglesType.ribbons;
      case "SquareTiles":
        return TrianglesType.squareTiles;
      case "DiamondTiles":
        return TrianglesType.diamondTiles;
      case "Tiles":
        return TrianglesType.tiles;
      default:
        return TrianglesType.randomJiggle; // Default fallback
    }
  }
}
