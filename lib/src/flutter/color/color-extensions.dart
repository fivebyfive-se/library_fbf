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
