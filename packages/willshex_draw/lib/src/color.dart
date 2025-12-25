//
//  color.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 SPACEHOPPER STUDIOS LTD. All rights reserved.
//

import 'dart:math' as m;

import 'package:willshex_draw/src/helper/named_color_helper.dart';

class Color {
  double _saturation = 0;
  double _brightness = 0;
  double _hue = 0;
  double _r = 0;
  double _g = 0;
  double _b = 0;
  double _a = 1.0;

  Color._();

  Color blend(Color sourceColor, [double amount = 0.5]) {
    // http://stackoverflow.com/questions/1944095/how-to-mix-two-argb-pixels

    double part = 2.0 * amount;

    double rOut =
        (sourceColor.r * sourceColor.a) + (_r * _b * (part - sourceColor.a));
    double gOut =
        (sourceColor.g * sourceColor.a) + (_g * _a * (part - sourceColor.a));
    double bOut =
        (sourceColor.b * sourceColor.a) + (_b * _a * (part - sourceColor.a));
    double aOut = sourceColor.a + (_a * (part - sourceColor.a));

    return Color.rgbaColor(
      rOut,
      gOut,
      bOut,
      aOut,
    );
  }

  Color contrasting([double amount = 0.2]) {
    throw Exception("Unsupported method contrasting");
  }

  Color darker([double amount = 0.2]) {
    Color darker = Color._();
    darker._saturation = _saturation;
    darker._brightness = _brightness;
    darker._hue = _hue;
    darker._r = _r;
    darker._g = _g;
    darker._b = _b;
    darker._a = _a;
    darker.brightness = (darker.brightness - amount);
    return darker;
  }

  Color lighter([double amount = 0.2]) {
    Color darker = Color._();
    darker._saturation = _saturation;
    darker._brightness = _brightness;
    darker._hue = _hue;
    darker._r = _r;
    darker._g = _g;
    darker._b = _b;
    darker._a = _a;
    darker.brightness = (darker.brightness + amount);
    return darker;
  }

  Color vary(double red, double green, double blue, [double alpha = 0.0]) {
    throw Exception("Unsupported method vary");
  }

  double get a => alpha;

  set a(double a) {
    alpha = a;
  }

  double get alpha => _a > 1.0 ? 1.0 : (_a < 0.0 ? 0.0 : _a);

  set alpha(double a) {
    _a = a;
  }

  double get b => blue;

  set b(double b) {
    blue = b;
  }

  double get blue {
    return (_b > 1.0 ? 1.0 : (_b < 0.0 ? 0.0 : _b));
  }

  set blue(double b) {
    _b = b;
    rgbToHsv();
  }

  double get g => green;

  set g(double g) {
    green = g;
  }

  double get green {
    return (_g > 1.0 ? 1.0 : (_g < 0.0 ? 0.0 : _g));
  }

  set green(double g) {
    _g = g;
    rgbToHsv();
  }

  double get r => red;

  set r(double r) {
    red = r;
  }

  double get red {
    return (_r > 1.0 ? 1.0 : (_r < 0.0 ? 0.0 : _r));
  }

  set red(double r) {
    _r = r;
    rgbToHsv();
  }

  double get brightness {
    return _brightness;
  }

  set brightness(double brightness) {
    _brightness = brightness;
    hsvtoRGB();
  }

  double get hue {
    return _hue;
  }

  set hue(double hue) {
    _hue = hue;
    hsvtoRGB();
  }

  double get saturation {
    return _saturation;
  }

  set saturation(double saturation) {
    _saturation = saturation;
    hsvtoRGB();
  }

  // http://www.cs.rit.edu/~ncs/color/t_convert.html
  // r,g,b values are from 0 to 1
  // h = [0,360], s = [0,1], v = [0,1]
  // if s == 0, then h = -1 (undefined)

  void rgbToHsv() {
    double min, max, delta;

    min = m.min(_r, m.min(_g, _b));
    max = m.max(_r, m.max(_g, _b));
    _brightness = max; // v

    delta = max - min;

    if (max != 0) {
      _saturation = delta / max; // s
    } else {
      // r = g = b = 0 // s = 0, v is undefined
      _saturation = 0;
      _hue = -1;
      return;
    }

    if (_r == max) {
      _hue = (_g - _b) / delta; // between yellow & magenta
    } else if (_g == max) {
      _hue = 2 + (_b - _r) / delta; // between cyan & yellow
    } else {
      _hue = 4 + (_r - _g) / delta; // between magenta & cyan
    }

    _hue *= 60; // degrees
    if (_hue < 0) _hue += 360;
  }

  void hsvtoRGB() {
    int i;
    double f, p, q, t;

    if (_saturation == 0) {
      // achromatic (grey)
      _r = _g = _b = _brightness;
      return;
    }

    double h = _hue;
    h /= 60; // sector 0 to 5
    i = h.floor();
    f = h - i; // factorial part of h
    p = _brightness * (1 - _saturation);
    q = _brightness * (1 - _saturation * f);
    t = _brightness * (1 - _saturation * (1 - f));

    switch (i) {
      case 0:
        _r = _brightness;
        _g = t;
        _b = p;
        break;
      case 1:
        _r = q;
        _g = _brightness;
        _b = p;
        break;
      case 2:
        _r = p;
        _g = _brightness;
        _b = t;
        break;
      case 3:
        _r = p;
        _g = q;
        _b = _brightness;
        break;
      case 4:
        _r = t;
        _g = p;
        _b = _brightness;
        break;
      default: // case 5:
        _r = _brightness;
        _g = p;
        _b = q;
        break;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is Color) {
      Color c = other;

      return c.a == a && c.b == b && c.g == g && c.r == r;
    }

    return super == other;
  }

  @override
  int get hashCode => super.hashCode + 1;

  factory Color.namedColor(
    String name, [
    double alpha = 1.0,
  ]) {
    Color color = NamedColorHelper.lookup(name);
    color.a = alpha;
    return color;
  }

  factory Color.grayscaleColor(
    double grayScale, [
    double alpha = 1.0,
  ]) {
    return Color.rgbaColor(grayScale, grayScale, grayScale, alpha);
  }

  factory Color.rgbaColor(
    double red,
    double green,
    double blue, [
    double alpha = 1.0,
  ]) {
    Color color = Color._();
    color.r = red;
    color.g = green;
    color.b = blue;
    color.a = alpha;
    return color;
  }
}
