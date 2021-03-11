import 'dart:ui';


import 'package:flutter/foundation.dart';

import '../ryb-color.dart';

/// Represents the current state of the picker widget.
/// Is immutable, so updates are new instances
@immutable
class RYBPickerState {
  RYBPickerState({
      double brightness = 0.0,
      int color = 0xff406020,
  }) : _brightness = brightness,
       _color = color;

  final double _brightness;
  final int _color;

  /// Current brightness as a value between
  /// [minBrightness] and [maxBrightness]
  double get brightness => _brightness;

  /// Current brightness normalized to a value between 0.0 and 1.0 
  double get brightnessRatio => (
    (brightness - minBrightness) / (maxBrightness - minBrightness)
  ).clamp(0.0, 1.0);

  /// Minimum value for [brightness]
  double get minBrightness => -0.95;

  /// Maximum value for [brightness]
  double get maxBrightness => 0.95;

  /// Alias for [brightness]
  double get currBrightness => brightness;

  /// Current color as [RYBColor]
  RYBColor
  get ryb => RYBColor(_color);

  /// Current [ryb] with alpha channel at max
  RYBColor
  get opaqueRYB => ryb.withAlpha(255);

  /// Current color at current brightness as a [Color]
  Color get color          
    => ryb.deltaBrightness(currBrightness).toColor();

  /// Complement of current color (with alpha locked to max)
  Color get colorComplement
    => opaqueRYB.complement().toColor();

  /// Current color at [minBrightness] (alpha at max)
  Color get colorDarkest
    => opaqueRYB.deltaBrightness(minBrightness).toColor();

  /// Current color with [brightness] at 0.0 (alpha at max)
  Color get colorMiddle
    => opaqueRYB.deltaBrightness(0).toColor();

  /// Current color at [maxBrightness] (alpha at max)
  Color get colorBrightest
    => opaqueRYB.deltaBrightness(maxBrightness).toColor();

  /// Return a clone of this state with the color set
  /// to [ryb]
  RYBPickerState withRYB(RYBColor ryb)
    => RYBPickerState(brightness: _brightness, color: ryb.value);

  /// Return a clone of this state with the brightness set
  /// to [b]
  RYBPickerState withBrightness(double b)
    => RYBPickerState(brightness: b, color: _color);

  /// Return a clone of this state with the brightnessRatio set
  /// to [r]
  RYBPickerState withBrightnessRatio(double r)
    => withBrightness((1.0 - r) * minBrightness + r * maxBrightness);

  /// Whether this instance is different from [old]
  bool shouldUpdate(RYBPickerState old)
    => old._brightness != _brightness ||
       old._color != _color;
}
