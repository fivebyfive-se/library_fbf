import 'dart:math' as math;

import 'package:flutter/painting.dart';

import 'hslcolor-extensions.dart';

extension FbfColorExtensions on Color {
  String toHex({bool includeHash = false, bool includeAlpha = false}) {
    final toHex = (int n) => n.toRadixString(16).padLeft(2, "0"); 
    return (includeHash ? '#' : '') + 
      toHex(this.red) + 
        toHex(this.green) + 
          toHex(this.blue) +
            (includeAlpha ? toHex(this.alpha) : "");
  }
  HSLColor toHSL() => HSLColor.fromColor(this);

  List<int> toList() => <int>[alpha, red, green, blue];
  List<double> toNormalizedList() => toList().map((v) => v / 255).toList();

  Color withChannel(int i, int v)
    => i == 0 ? withAlpha(v)
     : i == 1 ? withRed(v)
     : i == 2 ? withGreen(v)
     : i == 3 ? withBlue(v)
     : this;

  Color withNormalizedChannel(int i, double v)
    => withChannel(i, (v * 255).round());

  double get luma {
    final r = red   / 255;
    final g = green / 255;
    final b = blue  / 255;
    return 0.375 * r + 0.5 * g + 0.125 * b;
  }

  double contrast(Color other) 
    => _calcContrast(luma, other.luma);

  Color invert()
    => Color.fromARGB(
      this.alpha,
      0xff - this.red,
      0xff - this.green,
      0xff - this.blue
    );

  Color deltaHue(double degrees, { bool ryb = false })
    => this.toHSL().deltaHue(degrees, ryb: ryb).toColor();

  Color deltaSaturation(double delta)
    => this.toHSL().deltaSaturation(delta).toColor();

  Color deltaLightness(double delta)
    => this.toHSL().deltaLightness(delta).toColor();

  LinearGradient gradientTo(Color other, {Axis axis = Axis.vertical})
    => LinearGradient(
      begin: axis == Axis.vertical ? Alignment.topCenter : Alignment.centerLeft,
      end:   axis == Axis.vertical ? Alignment.bottomCenter : Alignment.centerRight,
      colors: [this, other]
    );
}

double _calcContrast(double l1, double l2)
  => l1 == l2 ? 0 : (math.max(l1,l2) + 0.05) / (math.min(l1,l2) + 0.05);
