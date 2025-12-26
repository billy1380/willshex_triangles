# WillShex Triangles - Dart/Flutter Port

This directory contains the Dart/Flutter port of the willshex-triangles Java project.

## Structure

### `/triangles/` - Core Triangle Generation Engine
- **`triangles_type.dart`** - Enum for different triangle generation types
- **`image_generator_config.dart`** - Configuration constants and enums
- **`store.dart`** - Interface for storing/loading generated images
- **`triangle_*.dart`** - Various triangle generation algorithms
- **`triangle_factory.dart`** - Factory for creating triangle generators
- **`helper/drawing_helper.dart`** - Helper utilities for drawing operations

### `/server/` - Server-Side Components
- **`image_generator.dart`** - Main image generation engine
- **`string_drawer.dart`** - Text rendering using bitmap fonts
- **`example_usage.dart`** - Examples of using server components

### `/desktop/` - Desktop Application Components
- **`triangles.dart`** - Main desktop application with CLI interface
- **`store/file_store.dart`** - File-based implementation of the Store interface
- **`graphics/random_color_palette.dart`** - Generator for random color palettes

## Usage Examples

### Using the Server Components

```dart
import 'package:willshex_triangles/triangles.dart';

// Generate an image with custom properties
final Map<String, String> properties = {
  'w': '800',           // width
  'h': '600',           // height
  't': 'RandomJiggle',  // triangle type
  'p': 'Random', // palette type
  'f': 'png',           // format
  'rd': '12',           // ratio denominator
  'rn': '1',            // ratio numerator
  'c': 'ColorBurn',     // composite mode
  'a': '0',             // annotate
};

// Create palette supplier
Future<Palette> paletteSupplier() async {
  final palette = RandomColorPalette();
  palette.generateRandomColors();
  return palette;
}

// Generate image
final format = await ImageGenerator.generate(
  properties,
  paletteSupplier,
  outputStream,
  store, // optional
);
```

### Using the Desktop CLI

```dart
import 'package:willshex_triangles/triangles.dart';

// Run the CLI application
await TrianglesCLI.run();

// Or use the main function directly
await Triangles.main([]);
```

### Using the Store Interface

```dart
// Create a file-based store
final Store store = FileStore();

// Save an image
final image = StoreImage(
  content: imageBytes,
  format: 'png',
);
store.save(image, 'my_image', 0);

// Load an image
final loadedImage = store.load('my_image', 0);
```

### Using Triangle Generators Directly

```dart
// Create a palette
final palette = Palette('My Palette');
palette.addColors([
  Color.rgbaColor(1.0, 0.0, 0.0),
  Color.rgbaColor(0.0, 1.0, 0.0),
  Color.rgbaColor(0.0, 0.0, 1.0),
]);

// Create bounds
final bounds = Rect(0, 0, 800, 600);

// Create triangle generator
final generator = TriangleFactory.create(
  TrianglesType.randomJiggle,
  palette,
  bounds,
);

// Generate triangles
final triangles = generator.generate();
```

## Configuration

The `ImageGeneratorConfig` class contains all the configuration constants:

- **Dimensions**: `widthKey`, `heightKey`, `defaultWidth`, `defaultHeight`
- **Triangle Type**: `typeKey`, `defaultType`
- **Palette**: `paletteKey`, `defaultPalette`
- **Ratio**: `ratioNKey`, `ratioDKey`, `defaultRatioN`, `defaultRatioD`
- **Composite**: `compositeKey`, `defaultComposite`
- **Format**: `formatKey`, `defaultFormat`
- **Annotation**: `annotateKey`, `defaultAnnotate`

## Dependencies

This port requires the following dependencies:
- `willshex_draw` - Drawing and color utilities
- `logging` - Logging functionality
- `dart:io` - File I/O operations
- `dart:convert` - JSON parsing
- `dart:math` - Mathematical operations
- `dart:typed_data` - Byte data handling

## Notes

- The image generation is currently a placeholder implementation
- Font loading in `StringDrawer` needs to be implemented based on your specific font format
- The COLOURlovers API integration may need updates based on current API changes
- Some advanced features like texture mapping and blending modes need full implementation

## Port Status

✅ **Completed:**
- Core triangle generation algorithms
- Configuration system
- Store interface and file implementation
- Local Random Color Palette generator
- CLI interface structure
- Type definitions and enums

🔄 **Needs Implementation:**
- Actual image rendering and export
- Font loading and text rendering
- Texture mapping
- Advanced blending modes
- Error handling and validation

📝 **Documentation:**
- API documentation
- Usage examples
- Configuration guide 