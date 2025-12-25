# Server Components

This directory contains server-side components for the willshex-triangles project, including image generation and text rendering capabilities.

## Components

### StringDrawer

The `StringDrawer` class provides comprehensive text rendering capabilities using bitmap fonts, including integrated font file loading and parsing.

#### Features

- **Font File Loading**: Loads .fnt files and parses their character definitions
- **Texture Loading**: Loads associated texture images (PNG, JPG, BMP, TGA)
- **Text Measurement**: Calculate text dimensions and character positions
- **Text Rendering**: Draw text to graphics contexts (placeholder implementation)
- **Character Data**: Provides access to character positioning, dimensions, and offsets
- **Kerning Support**: Handles character pair kerning for improved text spacing
- **Font Information**: Access to font metadata (name, size, line height, etc.)

#### Usage

```dart
import 'package:willshex_triangles/server/string_drawer.dart';

// Create a StringDrawer
final StringDrawer drawer = StringDrawer('Arial', 24);

// Load a font file
await drawer.loadFont('fonts/arial.fnt', texturePath: 'fonts/arial.png');

// Access font information
print('Font: ${drawer.fontName}');
print('Size: ${drawer.fontSize}');
print('Line height: ${drawer.lineHeight}');

// Get character data
final charData = drawer.getCharacter('A');
print('Character A width: ${charData['width']}');

// Calculate text dimensions
final width = drawer.getWidth('Hello World');
final height = drawer.getHeight('H');

// Get kerning between characters
final kerning = drawer.getKerning('A', 'V');
print('Kerning A-V: $kerning');

// Draw text (placeholder - requires graphics context implementation)
drawer.draw(graphics, 'Hello World', 100, 100);
```

#### .fnt File Format

The .fnt file format is a text-based format that defines bitmap font characters. It includes:

- **info**: Font metadata (name, size, style)
- **common**: Global font properties (line height, texture dimensions)
- **page**: Texture file references
- **char**: Individual character definitions
- **kerning**: Character pair spacing adjustments

Example .fnt file:
```
info face="Arial" size=24 bold=0 italic=0 charset="" unicode=1 stretchH=100 smooth=1 aa=1 padding=0,0,0,0 spacing=1,1 outline=0
common lineHeight=32 base=26 scaleW=256 scaleH=256 pages=1 packed=0
page id=0 file="arial.png"
chars count=95
char id=32   x=0   y=0   width=0   height=0   xoffset=0   yoffset=0   xadvance=8   page=0 chnl=15
char id=65   x=0   y=0   width=16  height=16  xoffset=0   yoffset=0   xadvance=16  page=0 chnl=15
kerning first=65 second=86 amount=-2
```

### ImageGenerator

The `ImageGenerator` class handles server-side image generation for triangle patterns.

#### Features

- **Parameter-based Generation**: Generate images from property maps
- **Multiple Formats**: Support for various image formats
- **Palette Integration**: Works with color palettes
- **Store Integration**: Save generated images to storage

#### Usage

```dart
import 'package:willshex_triangles/server/image_generator.dart';

// Create properties for image generation
final Map<String, String> properties = {
  'w': '800',
  'h': '600',
  't': 'RandomJiggle',
  'p': 'RandomColourLovers',
};

// Generate image
final format = await ImageGenerator.generate(
  properties,
  () async => Palette('Example'),
  outputFile.openWrite(),
  store,
);
```

## File Structure

```
lib/server/
├── string_drawer.dart            # Text rendering with integrated font loading
├── image_generator.dart          # Server-side image generation
├── example_usage.dart            # Example usage of server components
└── README.md                     # This documentation
```

## Dependencies

- `dart:io`: File system operations
- `dart:typed_data`: Binary data handling
- `package:logging`: Logging functionality
- `package:willshex_draw`: Drawing utilities

## Notes

- The text rendering implementation in `StringDrawer.draw()` is a placeholder
- Real graphics context integration would need to be implemented based on your rendering backend
- Font files (.fnt and textures) need to be provided separately
- The implementation supports standard .fnt file format used by tools like BMFont
- All font loading functionality is now integrated into StringDrawer for simplicity

## Example Files

- `example_usage.dart`: Shows integration of all server components

Run the examples to see the functionality in action:

```bash
dart lib/server/example_usage.dart
``` 