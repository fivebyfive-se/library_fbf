import 'dart:math';

import 'package:flutter/painting.dart';

import 'helpers.dart';
import 'color-extensions.dart';

/// [HSLColor]
extension HSLColorExtensions on HSLColor {
  HSLColor deltaHue(double degrees, {bool ryb = false}) {
    final hue = ryb ? hslToRyb(this.hue) : this.hue;
    final newHue = rotateValue(hue, degrees, 360);
    return this.withHue(ryb ? rybToHsl(newHue) : newHue);
  }

  HSLColor deltaLightness(double delta) {
    final deltaL = delta / 100.0;
    var newLightness = this.lightness + deltaL;
    var deltaS = (newLightness > 1.0)
      ? -(newLightness - 1.0)
        : (newLightness < 0.0)
          ? newLightness.abs() : 0;

    return this.deltaSaturation(deltaS * 100.0) 
            .withLightness(deltaRatio(this.lightness, delta));
  }

  HSLColor deltaSaturation(double delta)
    => this.withSaturation(deltaRatio(this.saturation, delta));

  HSLColor deltaAlpha(double delta)
    => this.withAlpha(deltaRatio(this.alpha, delta));

  /// HSLA
  List<double> toList()
    => [this.hue, this.saturation, this.lightness, this.alpha];

  String toHex({bool includeHash = false})
    => this.toColor().toHex(includeHash: includeHash);

  String toCss({bool hex = true}) 
    => hex ? this.toHex(includeHash: true) 
      : ["hsla(", [
          min(this.hue.roundToDouble(),359),
          this.saturation,
          this.lightness,
          this.alpha
        ].map((d) => d.toStringAsFixed(1))
          .toList().join(","),
        ")"].join("");
}

double deltaRatio(double value, double delta)
  => max(min(value + (delta / 100.0), 1.0), 0); 

double rotateValue(double value, double delta, double max, {double min = 0}) {
  final res = value + delta;

  return (res < min) ? res + (max - min)
    : (res > max) ? res - max
      : res;
}
