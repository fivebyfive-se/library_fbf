
class NumRange<T extends num> {
  const NumRange({this.min, this.max});

  const NumRange.from(this.min, this.max);

  final T min;
  final T max;

  /// get an Iterable ranging from [min] to [max], containing
  /// [count] elements
  Iterable<double> toIterable(int count, [int start = 0]) sync* {
    if (start < count) {
      yield lerp(start / (count-1));
      yield* toIterable(count, start + 1);
    }
  }

  /// Get an iterable ranging from [min] to [max], incrementing
  /// [step] between each item
  Iterable<T> toIterableByStep(T step) sync* {
    T value = min;
    while (value <= max) {
      yield value;
      value += step;
    }
  }

  /// Create an iterable ranging from [min] to [max], containing
  /// [count] elements
  static Iterable<double> iterable<S extends num>(S min, S max, int count)
    => NumRange<S>.from(min, max).toIterable(count);

  /// Create an iterable ranging from [min] to, at most, [max],
  /// with a distance of [step] between items
  static Iterable<S> stepIterable<S extends num>(S min, S max, S step)
    => NumRange<S>.from(min, max).toIterableByStep(step);

  /// Create a list ranging from [min] to [max], containing
  /// [count] elements
  static List<double> list(double min, double max, int count)
    => iterable(min, max, count).toList();

  /// Create a list ranging from [min] to, at most, [max],
  /// with a distance of [step] between items
  static List<S> stepList<S extends num>(S min, S max, S step)
    => stepIterable<S>(min, max, step).toList();

  /// Check if [value] is in range
  bool inRange(T value) => value >= min && value <= max;

  /// Linear interpolation: get value between `min` and `max`
  /// at the ratio `a`. 
  double lerp(double ratio)
    => min * (1.0 - ratio) + max * ratio;

  /// Inverse linear interpolation, get [value] as a ratio
  /// of the distance between [min] and [max]
  double invlerp(T value)
    => ((value - min) / (max - min)).clamp(0.0, 1.0);


  /// Map value to the target range
  double mapTo(T value, NumRange targetRange)
    => targetRange.lerp(invlerp(value));

  /// Map value from source range
  double mapFrom<S extends num>(S value, NumRange<S> sourceRange)
    => lerp(sourceRange.invlerp(value));
}
