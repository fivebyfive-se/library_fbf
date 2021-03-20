import 'package:flutter/cupertino.dart';

class FbfViewport {
  const FbfViewport(Size size)
    : _size = size;

  factory FbfViewport.of(BuildContext context) {
    return FbfViewport(MediaQuery.of(context).size);
  }

  static ViewportSize widthToSize(double width) {
    var viewportSize = ViewportSize.xs;
    if (width >= 576 && width < 768) {
      viewportSize = ViewportSize.md;
    } else if (width >= 768 && width < 992) {
      viewportSize = ViewportSize.lg;
    } else if (width >= 992 && width < 1200) {
      viewportSize = ViewportSize.xl;
    } else if (width >= 1200 && width < 1366) {
      viewportSize = ViewportSize.xxl;
    } else if (width >= 1366) {
      viewportSize = ViewportSize.xxxl;
    }
    return viewportSize;
  }

  final Size _size;

  double get width  => _size?.width  ?? 0.0;
  double get height => _size?.height ?? 0.0;

  ViewportSize get size => widthToSize(width);

  /// e.g.
  /// ```dart
  ///   int n = FbfViewport.of(context).responsive<int>({
  ///     ViewportSize.sm: () => 5,
  ///     ViewportSize.lg: () => 10
  ///   })  
  /// ```
  T responsive<T>(Map<ViewportSize, T Function()> breakpoints) {
    var useSize = size;
    while (!breakpoints.containsKey(useSize) && useSize.index > 0) {
      useSize = ViewportSize.values[useSize.index - 1];
    }
    if (breakpoints.containsKey(useSize)) {
      return breakpoints[useSize]();
    }
    return null;
  }
}

enum ViewportSize {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
  xxxl
}