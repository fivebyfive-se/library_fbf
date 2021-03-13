import 'dart:math';

import 'double.dart';

extension FbfRandomExtensions on Random {
  int nextIntValue([int min = 0, int max = 256])
    => nextInt(max - min) + min;

  double nextValue([double min = 0, double max = 1.0])
    => nextDouble().lerp(min, max);
}