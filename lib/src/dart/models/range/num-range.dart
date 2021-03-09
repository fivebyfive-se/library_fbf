
class NumRange {
  NumRange({this.min, this.max});

  final double min;
  final double max;

  Iterable<double> toIterator() sync* {
    var n = min;
    while (n <= max) {
      yield n++;
    }
  }

  /// Check if [value] is in range
  bool inRange(double value) => value >= min && value <= max;

  /// Linear interpolation: get value between `min` and `max`
  /// at the ratio `a`. 
  double lerp(double ratio)
    => min * (1.0 - ratio) + max * ratio;

  /// Inverse linear interpolation, get [value] as a ratio
  /// of the distance between [min] and [max]
  double invlerp(double value)
    => ((value - min) / (max - min)).clamp(0.0, 1.0);


  /// Map value to the target range
  double mapTo(double value, NumRange targetRange)
    => targetRange.lerp(invlerp(value));

  /// Map value from source range
  double mapFrom(double value, NumRange sourceRange)
    => lerp(sourceRange.invlerp(value));
}
