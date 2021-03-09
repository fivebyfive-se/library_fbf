import 'package:flutter/painting.dart';

import 'ryb-helpers.dart';

class RYBColor {
  RYBColor(this.value);

  RYBColor.fromARYB(int a, int r, int y, int b)
    : value = ((a & 0xff) << 24) | 
              ((r & 0xff) << 16) | 
              ((y & 0xff) << 8)  | 
               (b & 0xff);
  
  static RYBColor fromColor(Color c)
    => RYBColor(rgbToRyb(c.value));

  static RYBColor fromHSL(HSLColor h)
    => RYBColor(rgbToRyb(h.toColor().value));

  static RYBColor fromHSV(HSVColor h)
    => RYBColor(rgbToRyb(h.toColor().value));

  static RYBColor fromHex(String hex, {bool isRYB = true}) {
        String normHex = hex.replaceAll('#', '');
    if (normHex.length == 3 || normHex.length == 4) {
      normHex = normHex[0] + normHex[0] +
        normHex[1] + normHex[1] +
        normHex[2] + normHex[2] +
        (normHex.length == 4 ? normHex[3] + normHex[3] : '');
    }
    final hasAlpha = normHex.length == 8;
    final getPart = (int n, {int fallback = 0})
      => normHex.length >= n+2
        ? int.tryParse(
            normHex.substring(n, n+2),
            radix: 16
          ) ?? fallback
        : fallback;

    final a = hasAlpha ? getPart(0) : 255;
    final r = getPart(hasAlpha ? 2 : 0);
    final x = getPart(hasAlpha ? 4 : 2);
    final b = getPart(hasAlpha ? 6 : 4);
    final arxb = combineChannels(a, r, x, b);

    return RYBColor(isRYB ? arxb : rgbToRyb(arxb));
  }

  final int value;

  int get alpha  => (value & 0xff000000) >> 24;
  int get red    => (value & 0x00ff0000) >> 16;
  int get yellow => (value & 0x0000ff00) >> 8;
  int get blue   => (value & 0x000000ff);
  double get opacity => alpha / 0xff;

  RYBColor withAlpha(int a)  => RYBColor(rxbSetA(value, a));
  RYBColor withRed(int r)    => RYBColor(rxbSetR(value, r));
  RYBColor withYellow(int y) => RYBColor(rxbSetX(value, y));
  RYBColor withBlue(int b)   => RYBColor(rxbSetB(value, b));
  RYBColor withOpacity(double o)
    => RYBColor(rxbSetA(value, (o.clamp(0, 1.0) * 0xff).round()));

  RYBColor deltaAlpha(int a)  => withAlpha(alpha + a);
  RYBColor deltaRed(int r)    => withRed(red + r);
  RYBColor deltaYellow(int y) => withYellow(yellow + y);
  RYBColor deltaBlue(int b)   => withBlue(blue + b);
  RYBColor deltaOpacity(double o) => withOpacity(opacity + o);
  RYBColor deltaBrightness(double amount)
    => RYBColor(rxbChangeBrightness(value, amount.clamp(-1.0, 1.0)));

  RYBColor complement([double brightness = 0])
    => RYBColor(rxbComplementary(value, brightness));

  Iterable<RYBColor> neutrals([int count = 8, double brightness = 0])
    => rxbNeutrals(value, brightness.clamp(0.0, 1.0), count).map((v) => RYBColor(v)).toList();

  RYBColor rotate(double degrees, [int resolution = 181]) {
    final n = rxbNeutrals(value, 0.0, resolution);
    if (degrees < 0) {
      degrees = 360 - degrees;
    } else if (degrees >= 360) {
      degrees -= 360;
    }
    final int idx = (resolution * (degrees / 360)).round() % resolution; 

    return RYBColor(n.elementAt(idx));
  }

  Color toColor() => Color(rybToRgb(value));

  double computeLuminance()
    => toColor().computeLuminance();

  int distance(RYBColor b) => rxbDistance(value, b.value);

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other)
    => identical(this, other) || (
      other.runtimeType == runtimeType &&
      other is RYBColor &&
      other.value == value
    );
  
  @override
  String toString() => 'RYBColor(0x${value.toRadixString(16).padLeft(8, '0')})';

  static const channelMax = 0xff;
}

