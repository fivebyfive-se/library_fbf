import 'package:flutter/material.dart';

extension CodeThemeExtension on ThemeData {
  static FbfCodeTheme _codeTheme;
  
  FbfCodeTheme get codeTheme => _codeTheme ?? FbfCodeTheme();
  set codeTheme(FbfCodeTheme theme) => _codeTheme = theme;

  ThemeData withCodeTheme(FbfCodeTheme codeTheme) {
    this.codeTheme = codeTheme;
    return this;
  }
}

class FbfCodeTheme {
  FbfCodeTheme({
    this.subtitle1,
    this.subtitle2,
    this.bodyText1,
    this.bodyText2
  });

  TextStyle subtitle1;
  TextStyle subtitle2;
  TextStyle bodyText1;
  TextStyle bodyText2;

  FbfCodeTheme copyWith({
    TextStyle subtitle1,
    TextStyle subtitle2,
    TextStyle bodyText1,
    TextStyle bodyText2
  }) => FbfCodeTheme(
    subtitle1: subtitle1 ?? this.subtitle1,
    subtitle2: subtitle2 ?? this.subtitle2,
    bodyText1: bodyText1 ?? this.bodyText1,
    bodyText2: bodyText2 ?? this.bodyText2
  );
}