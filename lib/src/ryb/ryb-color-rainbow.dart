import 'dart:math';

import '../dart/extensions/iterable.dart';

import 'ryb-helpers.dart';
import 'ryb-color.dart';

const _max = RYBColor.channelMax;

class RYBColorRainbow {
  static List<int> _rainbow;

  static List<int> get rainbow => _rainbow ?? (_rainbow = _generateFull());
  static int get rainbowSize => rainbow.length;

  static int getRainbowStep(int step, int size) {
    if (size <= 0 || size >= rainbowSize) {
      return rainbow[step];
    } else {
      final int idx = (step * (rainbowSize / size)).floor();
      return rainbow[idx];
    }
  }

  static Iterable<int> getRainbow([int size = 0, int start = 0]) sync* {
    if (size <= 0 || size >= rainbowSize) {
      yield* rainbow;
    } else if (start < rainbowSize) {
      final double step = rainbowSize / size;
      final int idx = (step * start).floor();
      yield rainbow[idx];
      yield* getRainbow(size, start + 1);
    }    
  }

  static List<RYBColor> getRainbowColors([int size = 0, int start = 0]) {
    if (size <= 0 || size >= rainbowSize) {
      return rainbow.mapToList<int,RYBColor>((v) => RYBColor(v));
    }
    final List<RYBColor> result = [];

    final double step = rainbowSize / size;
    for (double n = 0.0; n.ceil() < rainbowSize; n += step) {
      final int idx = min(n.round(), rainbowSize - 1);
      result.add(RYBColor(rainbow[idx]));
    }

    return result;
  }

  static List<int> _generateFull() {
    const numcolors = 3; // 3 possible colors: r, x, b
    final List<int> allColors = [];
    var currColor = 0xffff0000; // aarrxxbb

    // generate a rainbow for all colors
    var addingcolor = true; // adding or subtracting color
    for (var n = 0; n < numcolors * 2; n++) {
      // color will loop twice, so grab the lower digit
      var currChannel = ((n + 2) % numcolors) + 1;

      // loop the possible values
      for (int i = 0; i <= _max; i++) {
        final val = addingcolor ? i : _max - i;
        currColor = rxbSetChannel(currColor, currChannel, val);
        // push a copy of the array
        allColors.add(currColor);
      }

      // flip the bit
      addingcolor = !addingcolor;
    }
    return allColors;
  }
}
