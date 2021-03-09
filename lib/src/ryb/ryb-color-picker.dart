import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../dart/models/tuple.dart';

import 'ryb-color.dart';
import 'ryb-color-rainbow.dart';
import 'ryb-helpers.dart';

const defaultWheelSize = 200.0;
const defaultSliderSize = 20.0;

class RYBColorPicker extends StatefulWidget {
  RYBColorPicker({this.size = defaultWheelSize});

  final double size;

  @override
  _RYBColorPickerState createState() => _RYBColorPickerState();
}

class _RYBColorPickerState extends State<RYBColorPicker> {
  _RYBPickerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = _RYBPickerController(
      wheelSize: widget.size,
      sliderHeight: defaultSliderSize,
      sliderAxis: Axis.horizontal
    );
  }

  @override
  Widget build(BuildContext context) {
    final double padding = _controller.sliderHeight / 2;
    return Container(
      height: _controller.wheelSize * 2 + _controller.sliderHeight * 4 + padding * 6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: _controller.sliderHeight * 2 + padding * 2,
            width: _controller.sliderHeight * 2 + padding * 2,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(_controller.sliderHeight)),
              color: _controller.color
            ),
          ),
          Container(height: padding),
          Container(
            height: _controller.wheelSize + padding * 2,
            width: _controller.wheelSize + padding * 2,
            padding: EdgeInsets.all(padding),
            child: GestureDetector(
              onTapUp: (tap) {
                print("wheel: ${tap.localPosition} ${tap.globalPosition}");
                setState(() => _controller.wheel.tap(tap.localPosition));
              },
              child: CustomPaint(
                size: Size(_controller.wheelSize, _controller.wheelSize),
                painter: _RYBPickerWheelPainter(
                  controller: _controller.wheel
                ),
              )
            ),
          ),
          Container(height: padding),
          Container(
            height: _controller.sliderHeight + padding * 2,
            width: _controller.wheelSize + padding * 2,
            padding: EdgeInsets.all(padding),
            child: GestureDetector(
              onTapUp: (tap) {
                print("slider: ${tap.localPosition}");
                setState(() => _controller.slider.tap(tap.localPosition));
              },
              child: CustomPaint(
                size: Size(widget.size, _controller.sliderHeight),
                painter: _RYBPickerSliderPainter(
                  controller: _controller.slider
                ),
              )
            )
          )
        ],
      )
    );
  }
}



///
/// Handles painting the brightness slider
/// 
class _RYBPickerSliderPainter extends CustomPainter {
  const _RYBPickerSliderPainter({
    this.controller
  });

  final _RYBSliderController controller;

  @override
  void paint(Canvas canvas, Size boxSize) {
    final rect = controller.rect();
    final gradient = ui.Gradient.linear(
      controller.gradientFrom(),
      controller.gradientTo(),
      controller.gradientColors(),
      [0, 0.5, 1.0]
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient;

    canvas.drawRRect(rect, paint); 
    controller.drawThumb(canvas);
  }

  @override
  bool shouldRepaint(_RYBPickerSliderPainter old)
    => controller.shouldRepaint(old.controller);
}

///
/// Handles painting the color wheel
/// 
class _RYBPickerWheelPainter extends CustomPainter {
  const _RYBPickerWheelPainter({
    this.controller
  });

  final _RYBWheelController controller;

  @override
  void paint(Canvas canvas, Size boxSize) {    
    final Offset center = controller.center;
    final Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center, 
      controller.radius + _RYBController.cursorStrokeWidth,
      circlePaint
    );
    for (int r = 0; r < _RYBWheelController.numRings; r++) {
      final double radius = controller.ringRadius(r);
      final List<Color> colors = controller.ringColors(r).toList();
      final List<double> stops = controller.ringColorStops(r).toList();
      final ringShader = ui.Gradient.sweep(center, colors, stops);
      final Paint ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = controller.strokeWidth
        ..shader = ringShader;

      canvas.drawCircle(center, radius, ringPaint);      
    }
    controller.drawThumb(canvas);
  }

  @override
  bool shouldRepaint(_RYBPickerWheelPainter oldDelegate) {
    return controller.shouldRepaint(oldDelegate.controller);
  }
}


/// Current selection
class _RYBPickerState {
  _RYBPickerState();

  double _brightness = 0.0;

  double get brightness => _brightness;
  set brightness(double value) => value.clamp(minBrightness, maxBrightness);

  double get brightnessRatio => (
    (brightness - minBrightness) / (maxBrightness - minBrightness)
  ).clamp(0.0, 1.0);
  set brightnessRatio(double ratio)
    => _brightness = (1 - ratio) * minBrightness + ratio * maxBrightness;

  int color         = 0xff408020;

  double get minBrightness => -0.95;
  double get maxBrightness => 0.95;

  int get colorDarkest   => rxbChangeBrightness(color, minBrightness);
  int get colorBrightest => rxbChangeBrightness(color, maxBrightness);

  double   get currBrightness => brightness;
  RYBColor get currRYBColor => RYBColor(color);
  Color    get currColor => RYBColor(
    rxbChangeBrightness(color, brightness)
  ).toColor();
}

/// Base
abstract class _RYBController {
  _RYBController(this.state);

  final _RYBPickerState state;

  static const double aliasing = 0.45;
  static const double circleRadians = 2 * math.pi; 
  static const double cursorStrokeWidth = 4.0;

  Paint get cursorPaint => Paint()
        ..color = state.currColor
        ..style = PaintingStyle.fill;

  Paint get cursorStroke => Paint()
        ..color = state.currRYBColor.complement().toColor()
        ..style = PaintingStyle.stroke
        ..strokeWidth = cursorStrokeWidth;

  void drawCursor(Canvas canvas, Offset pos) {
    canvas.drawCircle(pos, cursorStrokeWidth * 3, cursorPaint);
    canvas.drawCircle(pos, cursorStrokeWidth * 3, cursorStroke);
  }


  bool shouldRepaint(_RYBController old)
    => old.state.brightness != state.brightness ||
       old.state.color != state.color;

  Offset get cursorPos;
  void tap(Offset pos);
  void drawThumb(Canvas canvas);
}


/// WHeelController
class _RYBWheelController extends _RYBController {
  _RYBWheelController({
    this.size,
    _RYBPickerState state,
  }) : super(state);

  final double size;

  static const int numRings = 36;
  static const int numTicks = 24;

  double get radius => size / 2;
  Offset get center => Offset(radius, radius);
  double get radiusStep => (radius / numRings) + _RYBController.aliasing;
  double get strokeWidth => radiusStep + _RYBController.aliasing;
  double get tickRadians => _RYBController.circleRadians / numTicks;
  double get sweepAngle => tickRadians + _RYBController.aliasing;

  @override
  Offset get cursorPos {
    Tuple3<int,int,int> closest;

    for (int t = 0; t < _RYBWheelController.numTicks; t++) {
      for (int r = 0; r < _RYBWheelController.numRings; r++) {
        final wc = getRYBColor(r, t);
        final dist = wc.distance(state.currRYBColor);
        if (closest == null || dist < closest.item1) {
          closest = Tuple3(dist, r, t);
        }
      }
    }
    if (closest == null) {
      return center;
    }
    final angle = (tickRadians * closest.item3) - _RYBController.circleRadians;
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
  void tap(Offset pos) {
    final double dx = pos.dx - center.dx;
    final double dy = pos.dy - center.dy;
    final double rad = math.atan2(dy, dx) + _RYBController.circleRadians;
    final double dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    print("rad: $rad, dist: $dist");
    final int ring = numRings - (dist / radiusStep).ceil();
    final int tick = (rad / tickRadians).ceil() % numTicks;
    print("ring: $ring, tick: $tick");
    state.color = getColor(ring.clamp(0, numRings), tick.clamp(0, numTicks));
  }

  double ringRadius(int ring)
    => radius - (radiusStep * ring + _RYBController.aliasing);

  double tickStartAngle(int tick)
    => tickRadians * tick - _RYBController.aliasing;


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
class _RYBSliderController extends _RYBController {
  _RYBSliderController({
    this.mainAxisSize,
    this.crossAxisSize,
    this.axis,
    _RYBPickerState state,
  }): super(state);

  final double mainAxisSize;
  final double crossAxisSize;
  final Axis axis;

  double get mainAxisPos => mainAxisSize * (1.0 - state.brightnessRatio);
  double get crossAxisCenter => crossAxisSize / 2;
  
  @override
  Offset get cursorPos =>
    axis == Axis.horizontal
      ? Offset(mainAxisPos, crossAxisCenter)
      : Offset(crossAxisCenter, mainAxisPos);

  @override
  void drawThumb(Canvas canvas)
    => drawCursor(canvas, cursorPos);

  @override
  void tap(Offset pos) {
    final double mainAxisRatio = (
      axis == Axis.horizontal 
        ? pos.dx : pos.dy
    ) / mainAxisSize;
    state.brightnessRatio = 1.0 - mainAxisRatio;
  }

  RRect rect()
    => RRect.fromRectAndRadius(
          axis == Axis.horizontal
            ? ui.Rect.fromLTWH(0, 0, mainAxisSize, crossAxisSize)
            : ui.Rect.fromLTWH(0, 0, crossAxisSize, mainAxisSize),
          Radius.circular(_RYBController.cursorStrokeWidth)
      );

  List<int> gradient()
    => [state.colorDarkest,
        state.color, 
        state.colorBrightest];

  List<Color> gradientColors()
    => gradient().map((v) => RYBColor(v).toColor()).toList();

  Offset gradientTo()
    => axis == Axis.horizontal
      ? Offset(0, crossAxisCenter)
      : Offset(crossAxisCenter, 0);

  Offset gradientFrom()
    => axis == Axis.horizontal
      ? Offset(mainAxisSize, crossAxisCenter)
      : Offset(crossAxisCenter, mainAxisSize);
}


/// PickerController
class _RYBPickerController {
  _RYBPickerController({
    this.wheelSize,
    this.sliderAxis,
    this.sliderHeight,
  }) : state = _RYBPickerState();

  final _RYBPickerState state;
  final double wheelSize;
  final Axis sliderAxis;
  final double sliderHeight;

  _RYBWheelController _wheel;
  _RYBSliderController _slider;

  _RYBWheelController get wheel => _wheel ?? (
    _wheel = _RYBWheelController(size: wheelSize, state: state));

  _RYBSliderController get slider => _slider ?? (
    _slider  = _RYBSliderController(
      mainAxisSize: wheelSize,
      crossAxisSize: sliderHeight,
      axis: sliderAxis,
      state: state
    ));

  Color  get color      => state.currColor;
  double get brightness => (state.brightness * 100.0).roundToDouble();
}

