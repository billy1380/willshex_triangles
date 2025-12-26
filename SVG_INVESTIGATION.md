# SVG Mode Investigation

## Findings
`ImageRenderer` (in `lib/triangles/image_renderer.dart`) extends `Renderer` from the `willshex_draw` package.
This means the architecture already supports swapping renderers.

## Proposed Implementation

### 1. Create `SvgRenderer`
Create a new class `lib/triangles/svg_renderer.dart` that extends `Renderer`.

```dart
import 'package:willshex_draw/willshex_draw.dart';

class SvgRenderer extends Renderer {
  final StringBuffer _buffer = StringBuffer();
  final int width;
  final int height;

  SvgRenderer(this.width, this.height) {
    _buffer.writeln('<svg width="$width" height="$height" xmlns="http://www.w3.org/2000/svg">');
  }

  String toSvg() {
    _buffer.writeln('</svg>');
    return _buffer.toString();
  }

  @override
  void renderTriangle(Color color, Point p1, Point p2, Point p3, [bool useGradient = false]) {
    final String fill = _colorToHex(color);
    // Note: SVG gradients are more complex than simple fill. 
    // If useGradient is true, we might need to define a linearGradient in defs and reference it.
    // For MVP, we might fallback to average color or ignore gradient.
    
    _buffer.writeln('<polygon points="${p1.x},${p1.y} ${p2.x},${p2.y} ${p3.x},${p3.y}" fill="$fill" stroke="none" />');
  }

  @override
  void renderRect(Rect rect, Color c) {
    final String fill = _colorToHex(c);
    _buffer.writeln('<rect x="${rect.x}" y="${rect.y}" width="${rect.width}" height="${rect.height}" fill="$fill" />');
  }

  // ... Implement other methods ...
  
  String _colorToHex(Color c) {
    // Convert generic color to #RRGGBB
    // Opacity: fill-opacity="..."
  }
}
```

### 2. Update ImageGenerator
Refactor `ImageGenerator.dart` to optionally use `SvgRenderer` instead of `ImageRenderer`.
Since `TriangleTiles` and other algorithms accept `Renderer`, they can write to `SvgRenderer` without modification.

### 3. Display
Use `flutter_svg` package to display the generated string.

## Gradient Handling
`ImageRenderer` implements custom barycentric gradient drawing pixel-by-pixel.
SVG supports Linear Gradients. To replicate the "Game Gradient" (3 colors on vertices), SVG `linearGradient` might be an approximation, or we might need mesh gradients (SVG 2.0, rarely supported). 
For the MVP, standard flat colors or simple linear gradients are recommended. The "antialiasing" benefit of SVG is substantial for flat triangles.

## Conclusion
Implementation is straightforward due to existing `Renderer` abstraction.
Work should proceed on `feature/svg-mode` branch.
