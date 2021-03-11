import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../../dart/models/tuple.dart';

import '../ryb-color.dart';
import '../ryb-color-rainbow.dart';
import '../ryb-helpers.dart';

import 'ryb-picker-state.dart';

/// PickerController
class RYBPickerController {
  RYBPickerController({
    this.wheelSize,
    this.sliderAxis,
    this.sliderHeight,
    RYBPickerState state,
    Color initialColor,
    double initialBrightness = 0,
  }) : state = state ?? RYBPickerState(
    brightness: initialBrightness,
    color: RYBColor.fromColor(initialColor).value
  );

  final RYBPickerState state;
  final double wheelSize;
  final Axis sliderAxis;
  final double sliderHeight;

  RYBPickerController withState(RYBPickerState newState)
    => RYBPickerController(
      wheelSize: wheelSize,
      sliderAxis: sliderAxis,
      sliderHeight: sliderHeight,
      state: newState
    );

  RYBWheelController get wheel 
    => RYBWheelController(diameter: wheelSize, state: state);

  RYBSliderController get slider => RYBSliderController(
      mainAxisSize: wheelSize - sliderHeight * 2,
      crossAxisSize: sliderHeight,
      axis: sliderAxis,
      state: state
    );

  Color  get color      => state.color;
  double get brightness => (state.brightness * 100.0).roundToDouble();
}

/// Base
abstract class RYBController {
  RYBController(this.state);

  final RYBPickerState state;

  static const double aliasing = 0.45;
  static const double circleRadians = 2 * math.pi; 
  static const double cursorStrokeWidth = 4.0;

  Paint get cursorPaint => Paint()
        ..color = state.colorMiddle
        ..style = PaintingStyle.fill;

  Paint get cursorStroke => Paint()
        ..color = state.colorComplement
        ..style = PaintingStyle.stroke
        ..strokeWidth = cursorStrokeWidth;

  void drawCursor(Canvas canvas, Offset pos) {
    canvas.drawCircle(pos, cursorStrokeWidth * 3, cursorPaint);
    canvas.drawCircle(pos, cursorStrokeWidth * 3, cursorStroke);
  }

  bool shouldRepaint(RYBController old)
    => old.state.shouldUpdate(old.state) ||
       old.size != size ||
       old.cursorPos != cursorPos;

  Size get size;
  Offset get cursorPos;
  RYBPickerState tap(Offset pos);
  void drawThumb(Canvas canvas);
}


/// WHeelController
class RYBWheelController extends RYBController {
  RYBWheelController({
    this.diameter,
    RYBPickerState state,
  }) : super(state);

  final double diameter;

  static const int numRings = 36;
  static const int numTicks = 24;

  double get radius => diameter / 2;
  Offset get center => Offset(radius, radius);
  double get radiusStep => (radius / numRings) + RYBController.aliasing;
  double get strokeWidth => radiusStep + RYBController.aliasing;
  double get tickRadians => RYBController.circleRadians / numTicks;
  double get sweepAngle => tickRadians + RYBController.aliasing;

  @override
  Size get size => Size(diameter, diameter);

  @override
  Offset get cursorPos {
    Tuple3<int,int,int> closest;

    for (int t = 0; t < RYBWheelController.numTicks; t++) {
      for (int r = 0; r < RYBWheelController.numRings; r++) {
        final wc = getRYBColor(r, t);
        final dist = wc.distance(state.opaqueRYB);
        if (closest == null || dist < closest.item1) {
          closest = Tuple3(dist, r, t);
        }
      }
    }
    if (closest == null) {
      return center;
    }
    final angle = (tickRadians * closest.item3) - RYBController.circleRadians;
    final dist = radius - (radiusStep * closest.item2);
    return Offset(
      center.dx + math.cos(angle) * dist,
      center.dy + math.sin(angle) * dist
    );
  }

  @override
  void drawThumb(Canvas canvas)
    => drawCursor(canvas, cursorPos);

  @override
  RYBPickerState tap(Offset pos) {
    final double dx = pos.dx - center.dx;
    final double dy = pos.dy - center.dy;
    final double rad = math.atan2(dy, dx) + RYBController.circleRadians;
    final double dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    print("rad: $rad, dist: $dist");
    final int ring = numRings - (dist / radiusStep).ceil();
    final int tick = (rad / tickRadians).ceil() % numTicks;
    print("ring: $ring, tick: $tick");
    return state.withRYB(
      getRYBColor(ring.clamp(0, numRings), tick.clamp(0, numTicks))
        .withAlpha(state.ryb.alpha)
    );
  }

  double ringRadius(int ring)
    => radius - (radiusStep * ring + RYBController.aliasing);

  double tickStartAngle(int tick)
    => tickRadians * tick - RYBController.aliasing;


  Iterable<Color> ringColors(int ring) sync* {
    yield* getColors().map(
      (c) => RYBColor(c.elementAt(ring)).toColor()
    );
  }

  Iterable<double> ringColorStops(int ring, [int start = 0]) sync* {
    if (start < numTicks) {
      yield start == 0 ? 0.0 : start / numTicks;
      yield* ringColorStops(ring, start + 1);
    }
  }

  Iterable<Iterable<int>> getColors([int start = 0]) sync* {
    if (start < numTicks) {
      final ryb = RYBColorRainbow.getRainbowStep(start, numTicks);
      yield rxbNeutrals(ryb, state.brightness, numRings * 2 - 1);
      yield* getColors(start + 1);
    }
  }

  RYBColor getRYBColor(int ring, int tick)
    => RYBColor(getColor(ring, tick));

  int getColor(int ring, int tick)
    => getColors().elementAt(tick).elementAt(ring);
}


/// SliderController
class RYBSliderController extends RYBController {
  RYBSliderController({
    this.mainAxisSize,
    this.crossAxisSize,
    this.axis,
    RYBPickerState state,
  }): super(state);

  final double mainAxisSize;
  final double crossAxisSize;
  final Axis axis;

  double get mainAxisPos => mainAxisSize * (1.0 - state.brightnessRatio);
  double get crossAxisCenter => crossAxisSize / 2;

  double get horizontalSize 
    => axis == Axis.horizontal ? mainAxisSize : crossAxisSize;
  double get verticalSize
   => axis == Axis.horizontal ? crossAxisSize : mainAxisSize;
  
  @override
  Size get size => Size(horizontalSize, verticalSize);

  @override
  Offset get cursorPos =>
    axis == Axis.horizontal
      ? Offset(mainAxisPos, crossAxisCenter)
      : Offset(crossAxisCenter, mainAxisPos);

  @override
  void drawThumb(Canvas canvas)
    => drawCursor(canvas, cursorPos);

  @override
  RYBPickerState tap(Offset pos) {
    final double mainAxisRatio = (
      axis == Axis.horizontal 
        ? pos.dx : pos.dy
    ) / mainAxisSize;
    return state.withBrightnessRatio(1.0 - mainAxisRatio);
  }

  RRect rect()
    => RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, horizontalSize, verticalSize),
        Radius.circular(RYBController.cursorStrokeWidth)
      );

  List<Color> gradient()
    => [state.colorDarkest,
        state.colorMiddle, 
        state.colorBrightest];

  Offset gradientTo()
    => axis == Axis.horizontal
      ? Offset(0, crossAxisCenter)
      : Offset(crossAxisCenter, 0);

  Offset gradientFrom()
    => axis == Axis.horizontal
      ? Offset(mainAxisSize, crossAxisCenter)
      : Offset(crossAxisCenter, mainAxisSize);
}


