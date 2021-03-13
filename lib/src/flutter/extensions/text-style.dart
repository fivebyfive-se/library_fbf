import 'package:flutter/painting.dart';

extension FbfTextStyleExtensions on TextStyle {
  TextStyle withFontStyle(FontStyle s)
    => copyWith(fontStyle: s);

  TextStyle withFontWeight(FontWeight w)
    => copyWith(fontWeight: w);

  TextStyle withColor(Color c)
    => copyWith(color: c);
}