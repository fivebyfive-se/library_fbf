import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../extensions/iterable.dart';

class Kolor {
  Kolor.fromHSLA(
    double hue,
    double saturation,
    double lightness,
    double alpha
  ) : _ahsl = { 'h': hue, 's': saturation, 'l': lightness, 'a': alpha };

  static Kolor fromHSLColor(HSLColor c)
    => Kolor.fromHSLA(c.hue, c.saturation, c.lightness, c.alpha);

  static Kolor fromHSVColor(HSVColor v) {
    final l = v.value - v.value * v.saturation / 2.0;
    final m = min(l, 1-l); 
    return Kolor.fromHSLA(v.hue, m > 0 ? (v.value - l)/m : 0, l, v.alpha);
  }

  static Kolor fromColor(Color c)
    => fromRGBA(c.red, c.green, c.blue, c.alpha);

  static Kolor fromRGBA(int red, int green, int blue, int alpha) {
    final double r = red / 0xFF;
    final double g = green / 0xFF;
    final double b = blue / 0xFF;
    final double a = alpha / 0xFF;

    final double max = [r, g, b].max();
    final double min = [r, g, b].min();
    final double delta = max - min;

    final double hue = _getHue(r, g, b, max, delta);
    final double lightness = (max + min) / 2.0;
    // Saturation can exceed 1.0 with rounding errors, so clamp it.
    final double saturation = lightness == 1.0
      ? 0.0
      : ((delta / (1.0 - (2.0 * lightness - 1.0).abs())).clamp(0.0, 1.0));
    
    return Kolor.fromHSLA(hue, saturation, lightness, a);
  }

  final Map<String, double> _ahsl;
  Map<String, double> _ahsv;
  Map<String, double> _argb;
  Map<String, int> _rgba;

  double get hue => ahsl['h'];
  double get saturation => ahsl['s'];
  double get lightness => ahsl['l'];
  double get alpha => ahsl['a'];
  double get opacity => 1.0 - alpha;

  int get red   => rgba['r'];
  int get green => rgba['g'];
  int get blue  => rgba['b'];
  int get rgbAlpha => rgba['a'];

  int get argbValue => (rgbAlpha << 24) | (red << 16) | (green << 8) | blue;

  Map<String, double> get ahsl => _ahsl;
  Map<String,double>  get argb => _argb ?? (_argb = _calcARGB());
  Map<String,double>  get ahsv => _ahsv ?? (_ahsv = _calcAHSV());
  Map<String,int>     get rgba => _rgba ?? (_rgba = _calcRGBA());

  @override
  int get hashCode => hashValues(hue, saturation, lightness, alpha);

  @override
  bool operator ==(Object other)
    => identical(this, other) || ((other is Kolor) && (
      hue == other.hue &&
      saturation == other.saturation &&
      lightness == other.lightness &&
      alpha == other.alpha
    ));

  Kolor withAlpha(double a)
    => Kolor.fromHSLA(hue, saturation, lightness, a);
  
  Kolor withHue(double h)
    => Kolor.fromHSLA(h, saturation, lightness, alpha);
  
  Kolor withSaturation(double s)
    => Kolor.fromHSLA(hue, s, lightness, alpha);

  Kolor withLightness(double l)
    => Kolor.fromHSLA(hue, saturation, l, alpha);

  Kolor deltaHue(double h) {

  }

  String toHex({bool includeHash = true, bool includeAlpha = false}) {
    final h = (n) => n.toRadixString(16).padLeft(2, "0");
    return (includeHash ? '#' : '') +
      h(red) + h(green) + h(blue) + (includeAlpha ? h(rgbAlpha) : '');
  }

  HSLColor get hslColor 
    => HSLColor.fromAHSL(alpha, hue, saturation, lightness);

  HSVColor get hsvColor
    => HSVColor.fromAHSV(alpha, hue, ahsv['s'], ahsv['v']);

  Color get color => Color(argbValue);

  Map<String,double> _calcAHSV() {
    final v = saturation * min(lightness,1-lightness) + lightness;
    return {
      'h': hue,
      's': v > 0 ? 2-2 * lightness/v : 0,
      'v': v,
      'a': alpha
    };
  }

  Map<String,int> _calcRGBA() {
    final a = argb;
    final i = (n) => (n * 0xff).round();
    return {
      'r': i(a['r']),
      'g': i(a['g']),
      'b': i(a['b']),
      'a': i(a['a'])
    };
  }

  Map<String,double> _calcARGB() {
    final a = saturation * min(lightness, 1-lightness);
    final f = (n) {
      final k = (n + hue / 30).round() % 12;
      return lightness - a * max([k-3.0, 9.0-k, 1.0].min(),-1);
    };
    return {
      'r': f(0),
      'g': f(8),
      'b': f(4),
      'a': alpha
    };
  } 
}

double _getHue(double red, double green, double blue, double max, double delta) {
  if (max == 0.0 || delta == 0 || (red == green && green == blue)) {
    return 0.0;
  } else if (max == red) {
    return 60.0 * (((green - blue) / delta) % 6);
  } else if (max == green) {
    return 60.0 * (((blue - red) / delta) + 2);
  } else if (max == blue) {
    return 60.0 * (((red - green) / delta) + 4);
  }
  return 0;
}