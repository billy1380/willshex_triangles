//
//  rect.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 WillShex Limited. All rights reserved.
//

import 'package:willshex_draw/src/point.dart';

enum PointType {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  ;
}

class Rect {
  double height = 0;
  double width = 0;
  double x = 0;
  double y = 0;

  Rect._();

  Point getPoint(PointType type) {
    late Point point;

    switch (type) {
      case PointType.topLeft:
        point = Point.xyPoint(x, y + height);
        break;
      case PointType.topCenter:
        point = Point.xyPoint(midX, y + height);
        break;
      case PointType.topRight:
        point = Point.xyPoint(x + width, y + height);
        break;
      case PointType.centerLeft:
        point = Point.xyPoint(x, midY);
        break;
      case PointType.center:
        point = Point.xyPoint(midX, midY);

        break;
      case PointType.centerRight:
        point = Point.xyPoint(x + width, midY);
        break;
      case PointType.bottomLeft:
        point = Point.xyPoint(x, y);
        break;
      case PointType.bottomCenter:
        point = Point.xyPoint(midX, y);
        break;
      case PointType.bottomRight:
        point = Point.xyPoint(x + width, y);
        break;
    }

    return point;
  }

  Rect inset(int x, [int y = 0]) {
    Rect inset = Rect._();
    inset.x = this.x + x;
    inset.y = this.y + y;
    return inset;
  }

  Rect intersect(Rect rect) {
    throw Exception("Unsupported operation intersect");
  }

  Rect union(Rect rect) {
    throw Exception("Unsupported operation union");
  }

  bool get isEmpty {
    return height == 0 || width == 0;
  }

  double get midX {
    return x + (width * 0.5);
  }

  double get midY {
    return y + (height * 0.5);
  }

  factory Rect.xyWidthHeightRect(
      double x, double y, double width, double height) {
    Rect rect = Rect._();
    rect.x = x;
    rect.y = y;
    rect.width = width;
    rect.height = height;
    return rect;
  }

  factory Rect.rectRect(Rect rect) {
    return Rect.xyWidthHeightRect(rect.x, rect.y, rect.width, rect.height);
  }
}
