import 'dart:math';

import '../dart/extensions/iterable.dart';

import 'ryb-color.dart';

const int _max = RYBColor.channelMax;
int clampChannel(num d) => min(_max, d.abs().ceil()) & _max;

int combineChannels(num a, num r, num x, num b) {
  final int alpha = clampChannel(a);
  final int red   = clampChannel(r);
  final int ecks  = clampChannel(x);
  final int blue  = clampChannel(b);

  return (alpha << 24) | (red << 16) | (ecks << 8) | blue;
}

int rxbFromList(List<int> channels, [bool includesAlpha = false])
  => includesAlpha 
    ? combineChannels(channels[0], channels[1], channels[2], channels[3])
    : combineChannels(_max, channels[0], channels[1], channels[2]);

List<int> rxbToList(int rxb, [bool includeAlpha = false])
  => includeAlpha 
    ? [rxbGetA(rxb), rxbGetR(rxb), rxbGetX(rxb), rxbGetB(rxb)] 
    : [rxbGetR(rxb), rxbGetX(rxb), rxbGetB(rxb)];


int rxbGetA(int rxb) => (rxb & 0xff000000) >> 24;
int rxbGetR(int rxb) => (rxb & 0x00ff0000) >> 16;
int rxbGetX(int rxb) => (rxb & 0x0000ff00) >>  8;
int rxbGetB(int rxb) => (rxb & 0x000000ff);

int rxbGetG(int rgb) => rxbGetX(rgb);
int rxbGetY(int ryb) => rxbGetX(ryb);

int rxbSetA(int rxb, int a) => (rxb & 0x00ffffff) | (clampChannel(a) << 24);
int rxbSetR(int rxb, int r) => (rxb & 0xff00ffff) | (clampChannel(r) << 16);
int rxbSetX(int rxb, int x) => (rxb & 0xffff00ff) | (clampChannel(x) << 8);
int rxbSetB(int rxb, int b) => (rxb & 0xffffff00) |  clampChannel(b);

num _p2(num x) => pow(x, 2.0);

int rxbDistance(int a, int b)
  => sqrt(
    _p2(rxbGetA(a) - rxbGetA(b)) +
    _p2(rxbGetR(a) - rxbGetR(b)) +
    _p2(rxbGetX(a) - rxbGetX(b)) +
    _p2(rxbGetB(a) - rxbGetB(b)) 
  ).round();

/// [chan] 0 is A, [chan] 3 is B
int rxbSetChannel(int rxb, int chan, int val)
  => (chan == 0) ? rxbSetA(rxb, val) 
    : (chan == 1) ? rxbSetR(rxb, val)
    : (chan == 2) ? rxbSetX(rxb, val)
      : rxbSetB(rxb, val);

int rxbGetChannel(int rxb, int chan)
  => (chan == 0) ? rxbGetA(rxb)
    : (chan == 1) ? rxbGetR(rxb)
    : (chan == 2) ? rxbGetX(rxb)
      : rxbGetB(rxb);


int rgbToRyb(int rgb) {
  double r   = rxbGetR(rgb).toDouble();
  double g   = rxbGetG(rgb).toDouble();
  double b   = rxbGetB(rgb).toDouble();
  final alpha = rxbGetA(rgb);

    // Remove the whiteness from the color.
  final w = [r, g, b].min();
  r -= w;
  g -= w;
  b -= w;

  final mg = [r, g, b].max();

  var y = min(r, g);
  r -= y;
  g -= y;

  // If this unfortunate conversion combines blue and green, then cut each in
  // half to preserve the value's maximum range.
  if (b > 0 && g > 0) {
      b /= 2.0;
      g /= 2.0;
  }

  // Redistribute the remaining green.
  y += g;
  b += g;

  // Normalize to values.
  final my = [r, y, b].max();
  if (my > 0) {
      final n = mg / my;
      r *= n;
      y *= n;
      b *= n;
  }

  // Add the white back in.
  r += w;
  y += w;
  b += w;

  return combineChannels(alpha, r, y, b);
}

int rybToRgb(int ryb) {
  const List<List<double>> _magic = [
    [1,     1,     1],
    [1,     1,     0],
    [1,     0,     0],
    [1,     0.5,   0],
    [0.163, 0.373, 0.6],
    [0.0,   0.66,  0.2],
    [0.5,   0.0,   0.5],
    [0.2,   0.094, 0.0]
  ];
  final rxbCubicInt = (num t, num a, num b) {
    final w = t * t * (3 - 2 * t);
    return a + w * (b - a);
};


  final findX = (iR, iY, iB, int n) {
    var x0 = rxbCubicInt(iB, _magic[0][n], _magic[4][n]);
    var x1 = rxbCubicInt(iB, _magic[1][n], _magic[5][n]);
    var x2 = rxbCubicInt(iB, _magic[2][n], _magic[6][n]);
    var x3 = rxbCubicInt(iB, _magic[3][n], _magic[7][n]);
    var y0 = rxbCubicInt(iY, x0, x1);
    var y1 = rxbCubicInt(iY, x2, x3);
    return rxbCubicInt(iR, y0, y1) * 255.0;
  };

  final alpha = rxbGetA(ryb);
  final r     = rxbGetR(ryb).toDouble() / 255.0;
  final y     = rxbGetX(ryb).toDouble() / 255.0;
  final b     = rxbGetB(ryb).toDouble() / 255.0;
  
  final red   = findX(r, y, b, 0).ceil();
  final green = findX(r, y, b, 1).ceil();
  final blue  = findX(r, y, b, 2).ceil();

  return combineChannels(alpha, red, green, blue);
}

int rxbChangeBrightness(int rxb, double amount) {
  double a = rxbGetA(rxb).toDouble();
  double r = rxbGetR(rxb).toDouble();
  double x = rxbGetX(rxb).toDouble();
  double b = rxbGetB(rxb).toDouble();

  double stepR, stepX, stepB;
  if (amount > 0) {
    stepR = (_max - r) / _max;
    stepX = (_max - x) / _max;
    stepB = (_max - b) / _max;
  } else {
    stepR = r / _max;
    stepX = x / _max;
    stepB = b / _max;
  }

  r += stepR * amount * _max;
  x += stepX * amount * _max;
  b += stepB * amount * _max;

  return combineChannels(a, r, x, b);
}

int rxbComplementary(int ryb, [double brightness = 0.0]) {
  final rybStepped = rxbChangeBrightness(ryb, brightness);
  final alpha = rxbGetA(ryb);

  final r = rxbGetR(rybStepped);
  final y = rxbGetY(rybStepped);
  final b = rxbGetB(rybStepped);

  final ncolor = combineChannels(alpha, _max - r, _max - y, _max - b);

  return rxbChangeBrightness(ncolor, brightness);
}

List<int> rxbNeutrals(int ryb, [double brightness = 0, int count = 8]) {
  final comp = rxbComplementary(ryb, brightness);
  var cur = rxbChangeBrightness(ryb, brightness);
  var alpha = rxbGetA(cur);

  final double dr = (rxbGetR(comp) - rxbGetR(cur)) / (count - 1);
  final double dy = (rxbGetY(comp) - rxbGetY(cur)) / (count - 1);
  final double db = (rxbGetB(comp) - rxbGetB(cur)) / (count - 1);

  final List<int> res = [];
  for (var i = 0; i < count; i++) {
    res.add(cur);
    final nextR = rxbGetR(cur) + dr;
    final nextY = rxbGetY(cur) + dy;
    final nextB = rxbGetB(cur) + db;

    cur = combineChannels(alpha, nextR, nextY, nextB); 
  }

  return res;
}


