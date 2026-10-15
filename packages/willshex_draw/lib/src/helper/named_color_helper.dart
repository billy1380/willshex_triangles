//
//  named_color_helper.dart
//  willshex_draw
//
//  Created by William Shakour on 22 Jun 2013.
//  Copyright © 2013 WillShex Limited. All rights reserved.
//

import 'package:willshex_draw/src/color.dart';
import 'package:willshex_draw/src/helper/random_helper.dart';

abstract final class NamedColorHelper {
  NamedColorHelper._();

  static List<String>? _names;
  static Map<String, Color>? _lookup;

  static Color lookup(String name) {
    _lookup ??= {
      "AliceBlue".toLowerCase(): Color.rgbaColor(0xF0 / 0xFF, 0xF8 / 0xFF, 1.0),
      "AntiqueWhite".toLowerCase():
          Color.rgbaColor(0xFA / 0xFF, 0xEB / 0xFF, 0xD7 / 0xFF),
      "Aqua".toLowerCase(): Color.rgbaColor(0.0, 1.0, 1.0),
      "Aquamarine".toLowerCase():
          Color.rgbaColor(0x7F / 0xFF, 1.0, 0xD4 / 0xFF),
      "Azure".toLowerCase(): Color.rgbaColor(0xF0 / 0xFF, 1.0, 1.0),
      "Beige".toLowerCase():
          Color.rgbaColor(0xF5 / 0xFF, 0xF5 / 0xFF, 0xDC / 0xFF),
      "Bisque".toLowerCase(): Color.rgbaColor(1.0, 0xE4 / 0xFF, 0xC4 / 0xFF),
      "Black".toLowerCase(): Color.rgbaColor(0.0, 0.0, 0.0),
      "BlanchedAlmond".toLowerCase():
          Color.rgbaColor(1.0, 0xEB / 0xFF, 0xCD / 0xFF),
      "Blue".toLowerCase(): Color.rgbaColor(0.0, 0.0, 1.0),
      "BlueViolet".toLowerCase():
          Color.rgbaColor(0x8A / 0xFF, 0x2B / 0xFF, 0xE2 / 0xFF),
      "Brown".toLowerCase():
          Color.rgbaColor(0xA5 / 0xFF, 0x2A / 0xFF, 0x2A / 0xFF),
      "BurlyWood".toLowerCase():
          Color.rgbaColor(0xDE / 0xFF, 0xB8 / 0xFF, 0x87 / 0xFF),
      "CadetBlue".toLowerCase():
          Color.rgbaColor(0x5F / 0xFF, 0x9E / 0xFF, 0xA0 / 0xFF),
      "Chartreuse".toLowerCase(): Color.rgbaColor(0x7F / 0xFF, 1.0, 0.0),
      "Chocolate".toLowerCase():
          Color.rgbaColor(0xD2 / 0xFF, 0x69 / 0xFF, 0x1E / 0xFF),
      "Coral".toLowerCase(): Color.rgbaColor(1.0, 0x7F / 0xFF, 0x50 / 0xFF),
      "CornflowerBlue".toLowerCase():
          Color.rgbaColor(0x64 / 0xFF, 0x95 / 0xFF, 0xED / 0xFF),
      "Cornsilk".toLowerCase(): Color.rgbaColor(1.0, 0xF8 / 0xFF, 0xDC / 0xFF),
      "Crimson".toLowerCase():
          Color.rgbaColor(0xDC / 0xFF, 0x14 / 0xFF, 0x3C / 0xFF),
      "Cyan".toLowerCase(): Color.rgbaColor(0.0, 1.0, 1.0),
      "DarkBlue".toLowerCase(): Color.rgbaColor(0.0, 0.0, 0x8B / 0xFF),
      "DarkCyan".toLowerCase(): Color.rgbaColor(0.0, 0x8B / 0xFF, 0x8B / 0xFF),
      "DarkGoldenRod".toLowerCase():
          Color.rgbaColor(0xB8 / 0xFF, 0x86 / 0xFF, 0x0B / 0xFF),
      "DarkGray".toLowerCase():
          Color.rgbaColor(0xA9 / 0xFF, 0xA9 / 0xFF, 0xA9 / 0xFF),
      "DarkGreen".toLowerCase(): Color.rgbaColor(0.0, 0x64 / 0xFF, 0.0),
      "DarkKhaki".toLowerCase():
          Color.rgbaColor(0xBD / 0xFF, 0xB7 / 0xFF, 0x6B / 0xFF),
      "DarkMagenta".toLowerCase():
          Color.rgbaColor(0x8B / 0xFF, 0.0, 0x8B / 0xFF),
      "DarkOliveGreen".toLowerCase():
          Color.rgbaColor(0x55 / 0xFF, 0x6B / 0xFF, 0x2F / 0xFF),
      "Darkorange".toLowerCase(): Color.rgbaColor(1.0, 0x8C / 0xFF, 0.0),
      "DarkOrchid".toLowerCase():
          Color.rgbaColor(0x99 / 0xFF, 0x32 / 0xFF, 0xCC / 0xFF),
      "DarkRed".toLowerCase(): Color.rgbaColor(0x8B / 0xFF, 0.0, 0.0),
      "DarkSalmon".toLowerCase():
          Color.rgbaColor(0xE9 / 0xFF, 0x96 / 0xFF, 0x7A / 0xFF),
      "DarkSeaGreen".toLowerCase():
          Color.rgbaColor(0x8F / 0xFF, 0xBC / 0xFF, 0x8F / 0xFF),
      "DarkSlateBlue".toLowerCase():
          Color.rgbaColor(0x48 / 0xFF, 0x3D / 0xFF, 0x8B / 0xFF),
      "DarkSlateGray".toLowerCase():
          Color.rgbaColor(0x2F / 0xFF, 0x4F / 0xFF, 0x4F / 0xFF),
      "DarkTurquoise".toLowerCase():
          Color.rgbaColor(0.0, 0xCE / 0xFF, 0xD1 / 0xFF),
      "DarkViolet".toLowerCase():
          Color.rgbaColor(0x94 / 0xFF, 0.0, 0xD3 / 0xFF),
      "DeepPink".toLowerCase(): Color.rgbaColor(1.0, 0x14 / 0xFF, 0x93 / 0xFF),
      "DeepSkyBlue".toLowerCase(): Color.rgbaColor(0.0, 0xBF / 0xFF, 1.0),
      "DimGray".toLowerCase():
          Color.rgbaColor(0x69 / 0xFF, 0x69 / 0xFF, 0x69 / 0xFF),
      "DimGrey".toLowerCase():
          Color.rgbaColor(0x69 / 0xFF, 0x69 / 0xFF, 0x69 / 0xFF),
      "DodgerBlue".toLowerCase():
          Color.rgbaColor(0x1E / 0xFF, 0x90 / 0xFF, 1.0),
      "FireBrick".toLowerCase():
          Color.rgbaColor(0xB2 / 0xFF, 0x22 / 0xFF, 0x22 / 0xFF),
      "FloralWhite".toLowerCase():
          Color.rgbaColor(1.0, 0xFA / 0xFF, 0xF0 / 0xFF),
      "ForestGreen".toLowerCase():
          Color.rgbaColor(0x22 / 0xFF, 0x8B / 0xFF, 0x22 / 0xFF),
      "Fuchsia".toLowerCase(): Color.rgbaColor(1.0, 0.0, 1.0),
      "Gainsboro".toLowerCase():
          Color.rgbaColor(0xDC / 0xFF, 0xDC / 0xFF, 0xDC / 0xFF),
      "GhostWhite".toLowerCase():
          Color.rgbaColor(0xF8 / 0xFF, 0xF8 / 0xFF, 1.0),
      "Gold".toLowerCase(): Color.rgbaColor(1.0, 0xD7 / 0xFF, 0.0),
      "GoldenRod".toLowerCase():
          Color.rgbaColor(0xDA / 0xFF, 0xA5 / 0xFF, 0x20 / 0xFF),
      "Gray".toLowerCase():
          Color.rgbaColor(0x80 / 0xFF, 0x80 / 0xFF, 0x80 / 0xFF),
      "Green".toLowerCase(): Color.rgbaColor(0.0, 0x80 / 0xFF, 0.0),
      "GreenYellow".toLowerCase():
          Color.rgbaColor(0xAD / 0xFF, 1.0, 0x2F / 0xFF),
      "HoneyDew".toLowerCase(): Color.rgbaColor(0xF0 / 0xFF, 1.0, 0xF0 / 0xFF),
      "HotPink".toLowerCase(): Color.rgbaColor(1.0, 0x69 / 0xFF, 0xB4 / 0xFF),
      "IndianRed".toLowerCase():
          Color.rgbaColor(0xCD / 0xFF, 0x5C / 0xFF, 0x5C / 0xFF),
      "Indigo".toLowerCase(): Color.rgbaColor(0x4B / 0xFF, 0.0, 0x82 / 0xFF),
      "Ivory".toLowerCase(): Color.rgbaColor(1.0, 1.0, 0xF0 / 0xFF),
      "Khaki".toLowerCase():
          Color.rgbaColor(0xF0 / 0xFF, 0xE6 / 0xFF, 0x8C / 0xFF),
      "Lavender".toLowerCase():
          Color.rgbaColor(0xE6 / 0xFF, 0xE6 / 0xFF, 0xFA / 0xFF),
      "LavenderBlush".toLowerCase():
          Color.rgbaColor(1.0, 0xF0 / 0xFF, 0xF5 / 0xFF),
      "LawnGreen".toLowerCase(): Color.rgbaColor(0x7C / 0xFF, 0xFC / 0xFF, 0.0),
      "LemonChiffon".toLowerCase():
          Color.rgbaColor(1.0, 0xFA / 0xFF, 0xCD / 0xFF),
      "LightBlue".toLowerCase():
          Color.rgbaColor(0xAD / 0xFF, 0xD8 / 0xFF, 0xE6 / 0xFF),
      "LightCoral".toLowerCase():
          Color.rgbaColor(0xF0 / 0xFF, 0x80 / 0xFF, 0x80 / 0xFF),
      "LightCyan".toLowerCase(): Color.rgbaColor(0xE0 / 0xFF, 1.0, 1.0),
      "LightGoldenRodYellow".toLowerCase():
          Color.rgbaColor(0xFA / 0xFF, 0xFA / 0xFF, 0xD2 / 0xFF),
      "LightGray".toLowerCase():
          Color.rgbaColor(0xD3 / 0xFF, 0xD3 / 0xFF, 0xD3 / 0xFF),
      "LightGreen".toLowerCase():
          Color.rgbaColor(0x90 / 0xFF, 0xEE / 0xFF, 0x90 / 0xFF),
      "LightPink".toLowerCase(): Color.rgbaColor(1.0, 0xB6 / 0xFF, 0xC1 / 0xFF),
      "LightSalmon".toLowerCase():
          Color.rgbaColor(1.0, 0xA0 / 0xFF, 0x7A / 0xFF),
      "LightSeaGreen".toLowerCase():
          Color.rgbaColor(0x20 / 0xFF, 0xB2 / 0xFF, 0xAA / 0xFF),
      "LightSkyBlue".toLowerCase():
          Color.rgbaColor(0x87 / 0xFF, 0xCE / 0xFF, 0xFA / 0xFF),
      "LightSlateGray".toLowerCase():
          Color.rgbaColor(0x77 / 0xFF, 0x88 / 0xFF, 0x99 / 0xFF),
      "LightSteelBlue".toLowerCase():
          Color.rgbaColor(0xB0 / 0xFF, 0xC4 / 0xFF, 0xDE / 0xFF),
      "LightYellow".toLowerCase(): Color.rgbaColor(1.0, 1.0, 0xE0 / 0xFF),
      "Lime".toLowerCase(): Color.rgbaColor(0.0, 1.0, 0.0),
      "LimeGreen".toLowerCase():
          Color.rgbaColor(0x32 / 0xFF, 0xCD / 0xFF, 0x32 / 0xFF),
      "Linen".toLowerCase():
          Color.rgbaColor(0xFA / 0xFF, 0xF0 / 0xFF, 0xE6 / 0xFF),
      "Magenta".toLowerCase(): Color.rgbaColor(1.0, 0.0, 1.0),
      "Maroon".toLowerCase(): Color.rgbaColor(0x80 / 0xFF, 0.0, 0.0),
      "MediumAquaMarine".toLowerCase():
          Color.rgbaColor(0x66 / 0xFF, 0xCD / 0xFF, 0xAA / 0xFF),
      "MediumBlue".toLowerCase(): Color.rgbaColor(0.0, 0.0, 0xCD / 0xFF),
      "MediumOrchid".toLowerCase():
          Color.rgbaColor(0xBA / 0xFF, 0x55 / 0xFF, 0xD3 / 0xFF),
      "MediumPurple".toLowerCase():
          Color.rgbaColor(0x93 / 0xFF, 0x70 / 0xFF, 0xDB / 0xFF),
      "MediumSeaGreen".toLowerCase():
          Color.rgbaColor(0x3C / 0xFF, 0xB3 / 0xFF, 0x71 / 0xFF),
      "MediumSlateBlue".toLowerCase():
          Color.rgbaColor(0x7B / 0xFF, 0x68 / 0xFF, 0xEE / 0xFF),
      "MediumSpringGreen".toLowerCase():
          Color.rgbaColor(0.0, 0xFA / 0xFF, 0x9A / 0xFF),
      "MediumTurquoise".toLowerCase():
          Color.rgbaColor(0x48 / 0xFF, 0xD1 / 0xFF, 0xCC / 0xFF),
      "MediumVioletRed".toLowerCase():
          Color.rgbaColor(0xC7 / 0xFF, 0x15 / 0xFF, 0x85 / 0xFF),
      "MidnightBlue".toLowerCase():
          Color.rgbaColor(0x19 / 0xFF, 0x19 / 0xFF, 0x70 / 0xFF),
      "MintCream".toLowerCase(): Color.rgbaColor(0xF5 / 0xFF, 1.0, 0xFA / 0xFF),
      "MistyRose".toLowerCase(): Color.rgbaColor(1.0, 0xE4 / 0xFF, 0xE1 / 0xFF),
      "Moccasin".toLowerCase(): Color.rgbaColor(1.0, 0xE4 / 0xFF, 0xB5 / 0xFF),
      "NavajoWhite".toLowerCase():
          Color.rgbaColor(1.0, 0xDE / 0xFF, 0xAD / 0xFF),
      "Navy".toLowerCase(): Color.rgbaColor(0.0, 0.0, 0x80 / 0xFF),
      "OldLace".toLowerCase():
          Color.rgbaColor(0xFD / 0xFF, 0xF5 / 0xFF, 0xE6 / 0xFF),
      "Olive".toLowerCase(): Color.rgbaColor(0x80 / 0xFF, 0x80 / 0xFF, 0.0),
      "OliveDrab".toLowerCase():
          Color.rgbaColor(0x6B / 0xFF, 0x8E / 0xFF, 0x23 / 0xFF),
      "Orange".toLowerCase(): Color.rgbaColor(1.0, 0xA5 / 0xFF, 0.0),
      "OrangeRed".toLowerCase(): Color.rgbaColor(1.0, 0x45 / 0xFF, 0.0),
      "Orchid".toLowerCase():
          Color.rgbaColor(0xDA / 0xFF, 0x70 / 0xFF, 0xD6 / 0xFF),
      "PaleGoldenRod".toLowerCase():
          Color.rgbaColor(0xEE / 0xFF, 0xE8 / 0xFF, 0xAA / 0xFF),
      "PaleGreen".toLowerCase():
          Color.rgbaColor(0x98 / 0xFF, 0xFB / 0xFF, 0x98 / 0xFF),
      "PaleTurquoise".toLowerCase():
          Color.rgbaColor(0xAF / 0xFF, 0xEE / 0xFF, 0xEE / 0xFF),
      "PaleVioletRed".toLowerCase():
          Color.rgbaColor(0xDB / 0xFF, 0x70 / 0xFF, 0x93 / 0xFF),
      "PapayaWhip".toLowerCase():
          Color.rgbaColor(1.0, 0xEF / 0xFF, 0xD5 / 0xFF),
      "PeachPuff".toLowerCase(): Color.rgbaColor(1.0, 0xDA / 0xFF, 0xB9 / 0xFF),
      "Peru".toLowerCase():
          Color.rgbaColor(0xCD / 0xFF, 0x85 / 0xFF, 0x3F / 0xFF),
      "Pink".toLowerCase(): Color.rgbaColor(1.0, 0xC0 / 0xFF, 0xCB / 0xFF),
      "Plum".toLowerCase():
          Color.rgbaColor(0xDD / 0xFF, 0xA0 / 0xFF, 0xDD / 0xFF),
      "PowderBlue".toLowerCase():
          Color.rgbaColor(0xB0 / 0xFF, 0xE0 / 0xFF, 0xE6 / 0xFF),
      "Purple".toLowerCase(): Color.rgbaColor(0x80 / 0xFF, 0.0, 0x80 / 0xFF),
      "Red".toLowerCase(): Color.rgbaColor(1.0, 0.0, 0.0),
      "RosyBrown".toLowerCase():
          Color.rgbaColor(0xBC / 0xFF, 0x8F / 0xFF, 0x8F / 0xFF),
      "RoyalBlue".toLowerCase():
          Color.rgbaColor(0x41 / 0xFF, 0x69 / 0xFF, 0xE1 / 0xFF),
      "SaddleBrown".toLowerCase():
          Color.rgbaColor(0x8B / 0xFF, 0x45 / 0xFF, 0x13 / 0xFF),
      "Salmon".toLowerCase():
          Color.rgbaColor(0xFA / 0xFF, 0x80 / 0xFF, 0x72 / 0xFF),
      "SandyBrown".toLowerCase():
          Color.rgbaColor(0xF4 / 0xFF, 0xA4 / 0xFF, 0x60 / 0xFF),
      "SeaGreen".toLowerCase():
          Color.rgbaColor(0x2E / 0xFF, 0x8B / 0xFF, 0x57 / 0xFF),
      "SeaShell".toLowerCase(): Color.rgbaColor(1.0, 0xF5 / 0xFF, 0xEE / 0xFF),
      "Sienna".toLowerCase():
          Color.rgbaColor(0xA0 / 0xFF, 0x52 / 0xFF, 0x2D / 0xFF),
      "Silver".toLowerCase():
          Color.rgbaColor(0xC0 / 0xFF, 0xC0 / 0xFF, 0xC0 / 0xFF),
      "SkyBlue".toLowerCase():
          Color.rgbaColor(0x87 / 0xFF, 0xCE / 0xFF, 0xEB / 0xFF),
      "SlateBlue".toLowerCase():
          Color.rgbaColor(0x6A / 0xFF, 0x5A / 0xFF, 0xCD / 0xFF),
      "SlateGray".toLowerCase():
          Color.rgbaColor(0x70 / 0xFF, 0x80 / 0xFF, 0x90 / 0xFF),
      "Snow".toLowerCase(): Color.rgbaColor(1.0, 0xFA / 0xFF, 0xFA / 0xFF),
      "SpringGreen".toLowerCase(): Color.rgbaColor(0.0, 1.0, 0x7F / 0xFF),
      "SteelBlue".toLowerCase():
          Color.rgbaColor(0x46 / 0xFF, 0x82 / 0xFF, 0xB4 / 0xFF),
      "Tan".toLowerCase():
          Color.rgbaColor(0xD2 / 0xFF, 0xB4 / 0xFF, 0x8C / 0xFF),
      "Teal".toLowerCase(): Color.rgbaColor(0.0, 0x80 / 0xFF, 0x80 / 0xFF),
      "Thistle".toLowerCase():
          Color.rgbaColor(0xD8 / 0xFF, 0xBF / 0xFF, 0xD8 / 0xFF),
      "Tomato".toLowerCase(): Color.rgbaColor(1.0, 0x63 / 0xFF, 0x47 / 0xFF),
      "Turquoise".toLowerCase():
          Color.rgbaColor(0x40 / 0xFF, 0xE0 / 0xFF, 0xD0 / 0xFF),
      "Violet".toLowerCase():
          Color.rgbaColor(0xEE / 0xFF, 0x82 / 0xFF, 0xEE / 0xFF),
      "Wheat".toLowerCase():
          Color.rgbaColor(0xF5 / 0xFF, 0xDE / 0xFF, 0xB3 / 0xFF),
      "White".toLowerCase(): Color.rgbaColor(1.0, 1.0, 1.0),
      "WhiteSmoke".toLowerCase():
          Color.rgbaColor(0xF5 / 0xFF, 0xF5 / 0xFF, 0xF5 / 0xFF),
      "Yellow".toLowerCase(): Color.rgbaColor(1.0, 1.0, 0.0),
      "YellowGreen".toLowerCase():
          Color.rgbaColor(0x9A / 0xFF, 0xCD / 0xFF, 0x32 / 0xFF),
    };

    return _lookup![name.toLowerCase()]!;
  }

  static Color get randomNamedColor {
    _names ??= [
      "AliceBlue",
      "AntiqueWhite",
      "Aqua",
      "Aquamarine",
      "Azure",
      "Beige",
      "Bisque",
      "Black",
      "BlanchedAlmond",
      "Blue",
      "BlueViolet",
      "Brown",
      "BurlyWood",
      "CadetBlue",
      "Chartreuse",
      "Chocolate",
      "Coral",
      "CornflowerBlue",
      "Cornsilk",
      "Crimson",
      "Cyan",
      "DarkBlue",
      "DarkCyan",
      "DarkGoldenRod",
      "DarkGray",
      "DarkGreen",
      "DarkKhaki",
      "DarkMagenta",
      "DarkOliveGreen",
      "Darkorange",
      "DarkOrchid",
      "DarkRed",
      "DarkSalmon",
      "DarkSeaGreen",
      "DarkSlateBlue",
      "DarkSlateGray",
      "DarkTurquoise",
      "DarkViolet",
      "DeepPink",
      "DeepSkyBlue",
      "DimGray",
      "DimGrey",
      "DodgerBlue",
      "FireBrick",
      "FloralWhite",
      "ForestGreen",
      "Fuchsia",
      "Gainsboro",
      "GhostWhite",
      "Gold",
      "GoldenRod",
      "Gray",
      "Green",
      "GreenYellow",
      "HoneyDew",
      "HotPink",
      "IndianRed",
      "Indigo",
      "Ivory",
      "Khaki",
      "Lavender",
      "LavenderBlush",
      "LawnGreen",
      "LemonChiffon",
      "LightBlue",
      "LightCoral",
      "LightCyan",
      "LightGoldenRodYellow",
      "LightGray",
      "LightGreen",
      "LightPink",
      "LightSalmon",
      "LightSeaGreen",
      "LightSkyBlue",
      "LightSlateGray",
      "LightSteelBlue",
      "LightYellow",
      "Lime",
      "LimeGreen",
      "Linen",
      "Magenta",
      "Maroon",
      "MediumAquaMarine",
      "MediumBlue",
      "MediumOrchid",
      "MediumPurple",
      "MediumSeaGreen",
      "MediumSlateBlue",
      "MediumSpringGreen",
      "MediumTurquoise",
      "MediumVioletRed",
      "MidnightBlue",
      "MintCream",
      "MistyRose",
      "Moccasin",
      "NavajoWhite",
      "Navy",
      "OldLace",
      "Olive",
      "OliveDrab",
      "Orange",
      "OrangeRed",
      "Orchid",
      "PaleGoldenRod",
      "PaleGreen",
      "PaleTurquoise",
      "PaleVioletRed",
      "PapayaWhip",
      "PeachPuff",
      "Peru",
      "Pink",
      "Plum",
      "PowderBlue",
      "Purple",
      "Red",
      "RosyBrown",
      "RoyalBlue",
      "SaddleBrown",
      "Salmon",
      "SandyBrown",
      "SeaGreen",
      "SeaShell",
      "Sienna",
      "Silver",
      "SkyBlue",
      "SlateBlue",
      "SlateGray",
      "Snow",
      "SpringGreen",
      "SteelBlue",
      "Tan",
      "Teal",
      "Thistle",
      "Tomato",
      "Turquoise",
      "Violet",
      "Wheat",
      "White",
      "WhiteSmoke",
      "Yellow",
      "YellowGreen",
    ];

    return lookup(_names![RandomHelper.random.nextInt(_names!.length)]);
  }
}
