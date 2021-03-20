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
      viewportSize = ViewportSize.sm;
    } else if (width >= 768 && width < 992) {
      viewportSize = ViewportSize.md;
    } else if (width >= 992 && width < 1200) {
      viewportSize = ViewportSize.lg;
    } else if (width >= 1200 && width < 1366) {
      viewportSize = ViewportSize.xl;
    } else if (width >= 1366 && width < 1440) {
      viewportSize = ViewportSize.xxl;
    } else if (width >= 1440) {
      viewportSize = ViewportSize.xxxl;
    }
    return viewportSize;
  }

  final Size _size;

  ViewportSize get size => widthToSize(_size?.width ?? 0.0);

  Widget responsive(Map<ViewportSize, Widget Function()> breakpoints) {
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