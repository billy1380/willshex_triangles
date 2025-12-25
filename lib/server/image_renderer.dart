import 'package:image/image.dart' as img;
import 'package:willshex_draw/willshex_draw.dart';

class ImageRenderer extends Renderer {
  img.Image image;

  ImageRenderer(this.image);
  
  @override
  void renderGradientRect(Rect rect, Color c1, Color c2, Color c3, Color c4) {
    // TODO: implement renderGradientRect
  }
  
  @override
  void renderRect(Rect rect, Color c) {
    // TODO: implement renderRect
  }
  
  @override
  void renderTriangle(Color color, Point p1, Point p2, Point p3) {
    // TODO: implement renderTriangle
  }
}