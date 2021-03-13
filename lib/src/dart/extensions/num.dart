import 'double.dart';

extension FbfNumExtensions on num {
  /// Where this number falls between `min` and `max`
  /// as a ratio 0.0 - 1.0
  double invlerp(num min, num max)
    => ((this - min) / (max - min)).clamp(0.0, 1.0);

  num mod(num val) => this % val;

  num wrap(num max, {num min = 0}) => 
    this.mod(max - min) + min;

  /// Map this value from source range to target range
  num rangeMap(
    num sourceMin, num sourceMax,
    num targetMin, num targetMax
  ) => this.invlerp(sourceMin, sourceMax).lerp(targetMin, targetMax);
}
