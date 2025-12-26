//
//  palette.dart
//  willshex_draw
//
//  Created by William Shakour on 21 Jun 2013.
//  Copyright © 2013 WillShex Limited. All rights reserved.
//
import 'package:willshex_draw/src/color.dart';
import 'package:willshex_draw/src/helper/random_helper.dart';

class Palette {
  final List<Color> _colors = <Color>[];

  String? name;
  String? externalId;

  Palette([this.name, this.externalId]);

  void addColors(List<Color> colors) {
    _colors.addAll(colors);
  }

  Color operator [](int index) => _colors[index % _colors.length];

  int get count => _colors.length;

  List<Color> get colors => List.unmodifiable(_colors);

  Color get randomColor => this[RandomHelper.random.nextInt(count)];
}
