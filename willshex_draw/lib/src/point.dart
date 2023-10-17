//
//  point.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 SPACEHOPPER STUDIOS LTD. All rights reserved.
//
import 'dart:math';

class Point {
  Point._();

  double mX = 0;
  double mY = 0;

  Point operator+(Point pt) {
    Point added = Point._();
    added.x = (pt.x + x);
    added.y = (pt.y + y);
    return added;
  }

  Point operator-(Point pt) {
    Point subtracted = Point._();
    subtracted.x = (pt.x - x);
    subtracted.y = (pt.y - y);
    return subtracted;
  }

  double distance(Point pt) {
    return sqrt(pow(pt.x - x, 2) + pow(pt.y - y, 2));
  }

  double get x {
    return mX;
  }

  set x(double x) {
    mX = x;
  }

  double get y {
    return mY;
  }

  set y(double y) {
    mY = y;
  }

  factory Point.xyPoint(double x, double y) {
    Point point = Point._();
    point.x = x;
    point.y = y;
    return point;
  }

  factory Point.copy(Point pt) {
    return Point.xyPoint(pt.x, pt.y);
  }
}
