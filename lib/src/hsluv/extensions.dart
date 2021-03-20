import 'package:flutter/painting.dart';

import 'hsluv-color.dart';

extension ColorExtensions on Color {
  HSLuvColor toHSLuvColor()
    => HSLuvColor.fromColor(this);
}

extension HSLColorExtensions on HSLColor {
  HSLuvColor toHSLuvColor()
    => HSLuvColor.fromColor(this.toColor());
}
