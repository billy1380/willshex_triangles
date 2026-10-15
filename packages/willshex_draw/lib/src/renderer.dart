//
//  renderer.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 WillShex Limited. All rights reserved.
//
import 'package:willshex_draw/willshex_draw.dart';

abstract class Renderer {
  void renderTriangle(Color color, Point p1, Point p2, Point p3);
  void renderGradientRect(Rect rect, Color c1, Color c2, Color c3, Color c4);
  void renderRect(Rect rect, Color c);
}
