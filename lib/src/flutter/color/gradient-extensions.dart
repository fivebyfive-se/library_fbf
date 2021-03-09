
import 'package:flutter/painting.dart';

/// [Gradient]
extension FbfGradientExtensions on Gradient {
  LinearGradient toLinear() => (this as LinearGradient);
  Gradient reverse()  => this.toLinear().reverse();
}

/// [LinearGradient]
extension FbfLinearGradientExtensions on LinearGradient {
  BoxDecoration toDeco() => BoxDecoration(gradient:  this);

  LinearGradient reverse() 
    => LinearGradient(begin: end, end: begin, colors: colors);

  LinearGradient withBegin(AlignmentGeometry begin)
    => this.copyWith(begin: begin);

  LinearGradient withEnd(AlignmentGeometry end)
    => this.copyWith(end: end);

  LinearGradient withColors(List<Color> colors)
    => this.copyWith(colors: colors);

  LinearGradient withStops(List<double> stops)
    => this.copyWith(stops: stops);
  
  LinearGradient copyWith({
    AlignmentGeometry begin,
    AlignmentGeometry end,
    List<Color> colors,
    List<double> stops
  }) => LinearGradient(
    begin:  begin  ?? this.begin,
    end:    end    ?? this.end,
    colors: colors ?? this.colors,
    stops:  stops  ?? this.stops
  );
}