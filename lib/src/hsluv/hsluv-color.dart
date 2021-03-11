import 'dart:ui';

import 'package:flutter/painting.dart';

import 'hsluv.dart';

class HSLuvColor {
  /// Create a new [HSLuvColor]
  const HSLuvColor.fromAHSL(
    this.alpha,
    this.hue,
    this.saturation,
    this.lightness
  );

  /// Creates an [HSLuvColor] from an RGB [Color].
  ///
  /// This constructor does not necessarily round-trip with [toColor] because
  /// of floating-point imprecision.
  factory HSLuvColor.fromColor(Color color) {
    final double alpha = color.alpha / 0xFF;
    final double red = color.red / 0xFF;
    final double green = color.green / 0xFF;
    final double blue = color.blue / 0xFF;

    final List<double> luv = Hsluv.rgbToHsluv([red, green, blue]);

    final double hue = luv[0].roundToDouble();
    final double saturation = luv[1].roundToDouble();
    final double lightness = luv[2].roundToDouble();

    return HSLuvColor.fromAHSL(alpha, hue, saturation, lightness);
  }

  /// Alpha value, from 0.0 to 1.0
  final double alpha;

  /// Hue, from 0.0 to 360.0. Describes which color of the spectrum is
  /// represented. A value of 0.0 represents red, as does 360.0. Values in
  /// between go through all the hues representable in RGB. You can think of
  /// this as selecting which color filter is placed over a light.
  final double hue;

  /// Saturation, from 0.0 to 100.0. This describes how colorful the color is.
  /// 0.0 implies a shade of grey (i.e. no pigment), and 100.0 implies a color as
  /// vibrant as that hue gets. You can think of this as the purity of the
  /// color filter over the light.
  final double saturation;

  /// Lightness, from 0.0 to 100.0. The lightness of a color describes how bright
  /// a color is. A value of 0.0 indicates black, and 100.0 indicates white.
  final double lightness;

  /// Return a clone of this instance with the [alpha] channel set to the
  /// supplied value
  HSLuvColor withAlpha(double a)
    => HSLuvColor.fromAHSL(a, hue, saturation, lightness);

  /// Return a clone of this instance with the [hue] channel set to the
  /// supplied value
  HSLuvColor withHue(double h)
    => HSLuvColor.fromAHSL(alpha, h, saturation, lightness);
  
  /// Return a clone of this instance with the [saturation] channel set to the
  /// supplied value
  HSLuvColor withSaturation(double s)
    => HSLuvColor.fromAHSL(alpha, hue, s, lightness);
  
  /// Return a clone of this instance with the [lightness] channel set to the
  /// supplied value
  HSLuvColor withLightness(double l)
    => HSLuvColor.fromAHSL(alpha, hue, saturation, l);

  /// Returns this HSL color in RGB.
  Color toColor() {
    final rgb = Hsluv.hsluvToRgb([hue, saturation, lightness]);
    return Color.fromARGB(
      (alpha * 255).toInt(),
      (rgb[0] * 255).toInt(),
      (rgb[1] * 255).toInt(),
      (rgb[2] * 255).toInt()
    );
  }

  /// Returns this [HSLuvColor] as a "regular" [HSLColor]
  HSLColor toHSLColor()
    => HSLColor.fromColor(toColor());

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! HSLuvColor) return false;
    final HSLuvColor typedOther = other;
    return typedOther.hue == hue &&
        typedOther.saturation == saturation &&
        typedOther.lightness == lightness;
  }

  @override
  int get hashCode => hashValues(hue, saturation, lightness);

  @override
  String toString() => 'H:$hue S:$saturation L:$lightness';
}