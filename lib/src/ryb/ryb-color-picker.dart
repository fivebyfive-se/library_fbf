import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'color-picker/ryb-editor.dart';
import 'color-picker/ryb-picker-state.dart';
import 'color-picker/ryb-picker-controller.dart';

const defaultWheelSize = 200.0;
const defaultSliderSize = 20.0;

typedef PickerStateChange = void Function(RYBPickerState);
typedef ColorChangedHandler = void Function(Color);

/// A color picker widget, consisting of a color wheel,
/// a brightness slider, and inputs for red, yellow, blue,
/// and alpha channels
class RYBColorPicker extends StatefulWidget {
  /// Create a new instance
  RYBColorPicker({
    this.wheelSize = defaultWheelSize,
    this.axis = Axis.horizontal,
    this.sliderSize = defaultSliderSize,
    this.initialColor = Colors.amber,
    this.maxMainAxisSize,
    this.onChange
  });

  /// The diameter of the color wheel, and
  /// cross-axis length of slider 
  final double wheelSize;

  /// Main-axis size of the slider
  final double sliderSize;

  /// Maximum size of the entire widget in
  /// its main axis. Defaults to viewport size
  final double maxMainAxisSize;

  /// Main-axis direction. Defaults to [Axis.horizontal]
  final Axis axis;

  /// Initial color of the picker
  final Color initialColor;

  /// Called when the color is changed
  final ColorChangedHandler onChange;

  @override
  _RYBColorPickerState createState() => _RYBColorPickerState();
}

class _RYBColorPickerState extends State<RYBColorPicker> {
  RYBPickerController _controller;

  bool get _isVert  => widget.axis == Axis.vertical;
  Axis get _revAxis => _isVert ? Axis.horizontal : Axis.vertical;

  void _onChange(RYBPickerState newState) {
    if (_controller.state.shouldUpdate(newState)) {
      setState(() => _controller = _controller.withState(newState));
    }
  }
  
  @override
  void initState() {
    super.initState();

    _controller = RYBPickerController(
      wheelSize:    widget.wheelSize,
      sliderHeight: widget.sliderSize,
      sliderAxis:   _revAxis,
      initialColor: widget.initialColor
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size viewSize = MediaQuery.of(context).size;
    final double maxMainSize = widget.maxMainAxisSize ?? (
      _isVert ? viewSize.height : viewSize.width
    );

    final double padding = _controller.sliderHeight / 3;
    final double itemSize = _controller.wheelSize;
    final double itemWithPadding = itemSize + padding * 4;
    
    final double containerWidth  = _isVert ? itemWithPadding : maxMainSize;
    final double containerHeight = _isVert ? maxMainSize : itemWithPadding;
    final int maxFlex = 12;

    final item = (Widget child, [int flex = 4]) => Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(padding),
      width: _isVert ? itemWithPadding : containerWidth * (flex / maxFlex),
      height: _isVert ? containerHeight * (flex / maxFlex) : itemWithPadding,
      child: child
    );


    return Container(
      width: containerWidth,
      height: containerHeight,
      child: ListView(
        scrollDirection: widget.axis,
        children: <Widget>[
            item(
              RYBPainter.build<RYBWheelPainter>(
                RYBWheelPainter(controller: _controller.wheel),
                _onChange
              ),
              4
            ),
            item(
              RYBPainter.build<RYBSliderPainter>(
                RYBSliderPainter(controller: _controller.slider),
                _onChange
              ),
              2
            ),
            item(
              RYBEditor(
                color: _controller.state.ryb,
                onChanged: (ryb) => _onChange(_controller.state.withRYB(ryb)),
              ),
              6
            )
          ]),
      )
    ;
  }
}


abstract class RYBPainter<C extends RYBController> extends CustomPainter {
  const RYBPainter(this._controller);

  @protected
  final RYBController _controller;

  C get controller;

  @override
  bool shouldRepaint(RYBPainter old) => true;

  static Widget build<X extends RYBPainter>(X painter, PickerStateChange onChange) {
    return GestureDetector(
      onTapUp: (tap) => onChange?.call(painter.controller.tap(tap.localPosition)),
      child: CustomPaint(
        painter: painter,
        size: painter.controller.size
      )
    );
  }
} 


///
/// Handles painting the brightness slider
/// 
class RYBSliderPainter extends RYBPainter<RYBSliderController> {
  const RYBSliderPainter({
    RYBSliderController controller
  }) : super(controller);

  static RYBSliderPainter fromController(RYBPickerController ctrl)
    => RYBSliderPainter(controller: ctrl.slider);

 
  RYBSliderController get controller => _controller as RYBSliderController;

  @override
  void paint(Canvas canvas, Size boxSize) {
    final rect = controller.rect();
    final gradient = ui.Gradient.linear(
      controller.gradientFrom(),
      controller.gradientTo(),
      controller.gradient(),
      [0, 0.5, 1.0]
    );
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient;

    canvas.drawRRect(rect, paint); 
    controller.drawThumb(canvas);
  }

  // @override
  // bool shouldRepaint(RYBSliderPainter old)
  //   => controller.shouldRepaint(old.controller);
}

///
/// Handles painting the color wheel
/// 
class RYBWheelPainter extends RYBPainter<RYBWheelController> {
  const RYBWheelPainter({
    RYBWheelController controller
  }): super(controller);

  static RYBWheelPainter fromController(RYBPickerController ctrl)
    => RYBWheelPainter(controller: ctrl.wheel);

  @override
  RYBWheelController get controller => _controller as RYBWheelController;

  @override
  void paint(Canvas canvas, Size boxSize) {    
    final Offset center = controller.center;
    final Paint circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center, 
      controller.radius + RYBController.cursorStrokeWidth,
      circlePaint
    );
    for (int r = 0; r < RYBWheelController.numRings; r++) {
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

  // @override
  // bool shouldRepaint(RYBWheelPainter oldDelegate) {
  //   return controller.shouldRepaint(oldDelegate.controller);
  // }
}



