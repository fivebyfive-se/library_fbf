
extension FbfDoubleExtensions on double {
  /// Linear interpolation: get value between `x` and `y`
  /// at the ratio represented by this value.
  double lerp(num x, num y)
    => x * (1.0 - this.clamp(0.0, 1.0)) + y * this.clamp(0.0, 1.0);
}
