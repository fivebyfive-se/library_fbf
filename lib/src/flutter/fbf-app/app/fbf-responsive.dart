import 'package:flutter/cupertino.dart';

class FbfResponsive {
  const FbfResponsive(Size size)
    : _size = size;

  factory FbfResponsive.of(BuildContext context) {
    return FbfResponsive(MediaQuery.of(context).size);
  }

  static const double BreakpointXS = 0;
  static const double BreakpointSM = 600;
  static const double BreakpointMD = 960;
  static const double BreakpointLG = 1280;
  static const double BreakpointXL = 1920;

  static ViewportSize widthToSize(double width) {
    if (width < BreakpointSM) {
      return ViewportSize.xs;
    } else if (width < BreakpointMD) {
      return ViewportSize.sm;
    } else if (width < BreakpointLG) {
      return ViewportSize.md;
    } else if (width < BreakpointXL) {
      return ViewportSize.lg;
    }
    return ViewportSize.xl;
  }

  final Size _size;

  double get width  => _size?.width  ?? 0.0;
  double get height => _size?.height ?? 0.0;

  ViewportSize get size => widthToSize(width);

  /// Return the result of [builder] if the current viewport is
  /// less than [sz], otherwise the result of [orElse] (or null if
  /// [orElse] is omitted).
  T lt<T>(ViewportSize sz, T Function() builder, [T Function() orElse])
    => size.index < sz.index 
      ? builder()
      : orElse?.call();

  /// Return the result of [builder] if the current viewport is
  /// greater than [sz], otherwise the result of [orElse] (or null if
  /// [orElse] is omitted).
  T gt<T>(ViewportSize sz, T Function() builder, [T Function() orElse])
    => size.index > sz.index 
      ? builder()
      : orElse?.call();


  /// Return the result of [builder] if the current viewport is
  /// less than or equal to [sz], otherwise the result of [orElse] (or null if
  /// [orElse] is omitted).
  T lte<T>(ViewportSize sz, T Function() builder, [T Function() orElse])
    => size.index <= sz.index 
      ? builder()
      : orElse?.call();

  /// Return the result of [builder] if the current viewport is
  /// greater than or equal to [sz], otherwise the result of [orElse] (or null if
  /// [orElse] is omitted).
  T gte<T>(ViewportSize sz, T Function() builder, [T Function() orElse])
    => size.index >= sz.index 
      ? builder()
      : orElse?.call();

  /// Return the result of [builder] if the current viewport is
  /// equal to [sz], otherwise the result of [orElse] (or null if
  /// [orElse] is omitted).
  T only<T>(ViewportSize sz, T Function() builder, [T Function() orElse])
    => size == sz
      ? builder()
      : orElse?.call(); 
}

enum ViewportSize {
  xs,
  sm,
  md,
  lg,
  xl,
}