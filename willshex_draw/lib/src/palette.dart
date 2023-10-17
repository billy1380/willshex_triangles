//
//  palette.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 SPACEHOPPER STUDIOS LTD. All rights reserved.
//
import 'dart:math';

import 'package:willshex_draw/src/color.dart';

class Palette {
  static final Random mRandom = Random();

  final List<Color> _colors = <Color>[];

  String? name;
  String? externalId;
  String? source;

  Palette([this.name, this.externalId, this.source]);

  void addColors(List<Color> colors) {
    for (int i = 0; i < colors.length; i++) {
      _colors.add(colors[i]);
    }
  }

  Color operator [](int index) => _colors[index];

  int get count => _colors.length;

  List<Color> get colors => List.unmodifiable(_colors);

  Color get randomColor => this[mRandom.nextInt(count)];
}
