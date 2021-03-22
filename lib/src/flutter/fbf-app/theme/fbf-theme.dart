import 'package:flutter/material.dart';
import '../../color.dart';

import 'color-triad.dart';
import 'fbf-code-theme.dart';
import 'fbf-font-theme.dart';
import 'fbf-layout-theme.dart';

class FbfTheme {
  FbfTheme({
    this.fontTheme,
    this.layoutTheme,
    this.brightness = Brightness.dark,

    this.background = Colors.black,
    this.foreground = Colors.white,
    this.foregroundDisabled = Colors.grey,

    this.primaryTriad,
    this.secondaryTriad,
    this.tertiaryTriad,

    this.appBarBackground,
    this.appBarForeground,

    Color onPrimary,
    Color onSecondary,
    Color onTertiary,

    ColorTriad focus,
    ColorTriad highlight,
  
    LinearGradient drawerBackgroundGradient,
    LinearGradient backgroundGradient,
    LinearGradient logoBackgroundGradient,
    LinearGradient splashGradientStart,
    LinearGradient splashGradientEnd,

    Color cardBackground,
    Color cardForeground,

    Color dialogBackground,
    Color dialogForeground,

    Color bottomNavBackground,
    Color bottomNavForeground,
    Color bottomNavSelected,
    Color bottomNavDisabled,

    Color error,
    Color warning,

  }) :
      this.focusTriad = focus ?? primaryTriad,
      this.highlightTriad = highlight ?? secondaryTriad,

      this.onPrimary = onPrimary ?? foreground,
      this.onSecondary = onSecondary ?? foreground,
      this.onTertiary = onTertiary ?? foreground,

      this.backgroundGradient = backgroundGradient 
        ?? background.gradientTo(background.withAlpha(0x80)),

      this.logoBackgroundGradient = logoBackgroundGradient
        ?? primaryTriad.base.gradientTo(secondaryTriad.base),
      this.drawerBackgroundGradient = drawerBackgroundGradient
        ?? focus.base.gradientTo(tertiaryTriad.light),
      this.splashGradientStart = splashGradientStart ?? logoBackgroundGradient,
      this.splashGradientEnd   = splashGradientEnd ?? logoBackgroundGradient.reverse(),

      this.cardBackground = cardBackground ?? background,
      this.cardForeground = cardForeground ?? foreground,
      this.dialogBackground = dialogBackground ?? background,
      this.dialogForeground = dialogForeground ?? foreground,

      this.bottomNavBackground = bottomNavBackground ?? cardBackground,
      this.bottomNavForeground = bottomNavForeground ?? cardForeground,
      this.bottomNavSelected = bottomNavSelected ?? highlight?.light ?? secondaryTriad.light,
      this.bottomNavDisabled = bottomNavDisabled ?? foregroundDisabled,

      this.error = error ?? Colors.redAccent,
      this.warning = warning ?? Colors.deepOrangeAccent
    ;

  final FbfFontTheme fontTheme;
  final FbfLayoutTheme layoutTheme;

  final Brightness brightness;

  final ColorTriad primaryTriad;
  final ColorTriad secondaryTriad;
  final ColorTriad tertiaryTriad;

  final Color onPrimary;
  final Color onSecondary;
  final Color onTertiary;

  final ColorTriad focusTriad;
  final ColorTriad highlightTriad;
  
  final Color background;
  final Color foreground;
  final Color foregroundDisabled;

  final LinearGradient backgroundGradient;
  final LinearGradient logoBackgroundGradient;
  final LinearGradient drawerBackgroundGradient;
  final LinearGradient splashGradientStart;
  final LinearGradient splashGradientEnd;

  final Color cardBackground;
  final Color cardForeground;

  final Color dialogBackground;
  final Color dialogForeground;

  final Color appBarBackground;
  final Color appBarForeground;

  final Color bottomNavBackground;
  final Color bottomNavForeground;
  final Color bottomNavSelected;
  final Color bottomNavDisabled;

  final Color error;
  final Color warning;

  bool get isDark => brightness == Brightness.dark;

  Color get primary => primaryTriad.base;
  Color get secondary => secondaryTriad.base;
  Color get tertiary => tertiaryTriad.base;
  Color get focus => focusTriad.base;
  Color get highlight => highlightTriad.base;

  Color get primaryAccent => isDark ? primaryTriad.light : primaryTriad.dark;
  Color get secondaryAccent => isDark ? secondaryTriad.light : secondaryTriad.dark;
  Color get tertiaryAccent => isDark ? tertiaryTriad.light : tertiaryTriad.dark;
  Color get focusAccent => isDark ? focusTriad.light : focusTriad.dark;
  Color get highlightAccent => isDark ? highlightTriad.light : highlightTriad.dark;

  Color get primaryBackground => !isDark ? primaryTriad.light : primaryTriad.dark;
  Color get secondaryBackground => !isDark ? secondaryTriad.light : secondaryTriad.dark;
  Color get tertiaryBackground => !isDark ? tertiaryTriad.light : tertiaryTriad.dark;
  Color get focusBackground => !isDark ? focusTriad.light : focusTriad.dark;
  Color get highlightBackground => !isDark ? highlightTriad.light : highlightTriad.dark;

  @override
  int get hashCode => hashList([
      brightness,
      primaryTriad,
      secondaryTriad,
      tertiaryTriad,
      focusTriad,
      highlightTriad,
      background,
      foreground,
      foregroundDisabled,
      backgroundGradient,
      logoBackgroundGradient,
      drawerBackgroundGradient,
      splashGradientStart,
      splashGradientEnd,
      cardBackground,
      cardForeground,
      dialogBackground,
      dialogForeground,
      appBarBackground,
      appBarForeground,
      bottomNavBackground,
      bottomNavForeground,
      bottomNavSelected,
      bottomNavDisabled,
      error,
      warning,
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FbfTheme &&
      other.brightness == brightness &&
      other.primaryTriad == primaryTriad &&
      other.secondaryTriad == secondaryTriad &&
      other.tertiaryTriad == tertiaryTriad &&
      other.focusTriad == focusTriad &&
      other.highlightTriad == highlightTriad &&
      other.background == background &&
      other.foreground == foreground &&
      other.foregroundDisabled == foregroundDisabled &&
      other.backgroundGradient == backgroundGradient &&
      other.logoBackgroundGradient == logoBackgroundGradient &&
      other.drawerBackgroundGradient == drawerBackgroundGradient &&
      other.splashGradientStart == splashGradientStart &&
      other.splashGradientEnd == splashGradientEnd &&
      other.cardBackground == cardBackground &&
      other.cardForeground == cardForeground &&
      other.dialogBackground == dialogBackground &&
      other.dialogForeground == dialogForeground &&
      other.appBarBackground == appBarBackground &&
      other.appBarForeground == appBarForeground &&
      other.bottomNavBackground == bottomNavBackground &&
      other.bottomNavForeground == bottomNavForeground &&
      other.bottomNavSelected == bottomNavSelected &&
      other.bottomNavDisabled == bottomNavDisabled &&
      other.error == error &&
      other.warning == warning;
  }

  @protected
  Map<String,TextStyle> _codeHighlightTheme;

  Map<String,TextStyle> get codeHighlightTheme
    => _codeHighlightTheme ?? (_codeHighlightTheme = {
    'root':
        TextStyle(color: foreground, backgroundColor: background),
    'comment': TextStyle(color: foregroundDisabled, fontStyle: FontStyle.italic),
    'quote': TextStyle(color: focusAccent, fontStyle: FontStyle.italic),
    'keyword': TextStyle(color: highlightAccent, fontWeight: FontWeight.bold),
    'selector-tag':
        TextStyle(color: highlightAccent, fontWeight: FontWeight.bold),
    'subst': TextStyle(color: highlightAccent, fontWeight: FontWeight.normal),
    'number': TextStyle(color: primaryAccent),
    'literal': TextStyle(color: secondaryAccent),
    'variable': TextStyle(color: tertiaryAccent),
    'template-variable': TextStyle(color: tertiaryTriad.base),
    'string': TextStyle(color: focusAccent),
    'doctag': TextStyle(color: focus),
    'title': TextStyle(color: focus, fontWeight: FontWeight.bold),
    'section': TextStyle(color: focus, fontWeight: FontWeight.bold),
    'selector-id':
        TextStyle(color: highlight, fontWeight: FontWeight.bold),
    'type': TextStyle(backgroundColor: primaryBackground, color: onPrimary, fontWeight: FontWeight.bold),
    'tag': TextStyle(color: highlightAccent, fontWeight: FontWeight.normal),
    'name': TextStyle(color: highlight, fontWeight: FontWeight.normal),
    'attribute':
        TextStyle(color: secondaryAccent, fontWeight: FontWeight.normal),
    'regexp': TextStyle(color: focusAccent),
    'link': TextStyle(backgroundColor: tertiaryBackground, color: onTertiary),
    'symbol': TextStyle(color: tertiaryAccent),
    'bullet': TextStyle(color: highlightAccent),
    'built_in': TextStyle(color: secondary),
    'builtin-name': TextStyle(color: tertiaryAccent),
    'meta': TextStyle(color: secondaryAccent, fontWeight: FontWeight.bold),
    'deletion': TextStyle(backgroundColor: error),
    'addition': TextStyle(backgroundColor: highlightAccent),
    'emphasis': TextStyle(fontStyle: FontStyle.italic),
    'strong': TextStyle(fontWeight: FontWeight.bold),
  });
 

  @protected
  ThemeData _themeData;

  ThemeData get themeData => _themeData ?? (
    _themeData = ThemeData(
      brightness:      brightness,
      backgroundColor: background,
      canvasColor:     background,

      primaryColor:    primaryTriad.base,
      primaryColorDark: primaryTriad.dark,
      primaryColorLight: primaryTriad.light,

      accentColor:     secondaryTriad.base,

      splashColor:     tertiaryTriad.base,
      focusColor:      focusTriad.base,
      
      errorColor:      error,
      
      cardColor:       cardBackground,
      buttonColor:     primaryTriad.base,

      dialogBackgroundColor: dialogBackground,
      
      textTheme: fontTheme.textTheme,
      fontFamily: fontTheme.fontBody,
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: primary.toMaterialProp(),
          foregroundColor: onPrimary.toMaterialProp()
        )
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: secondaryAccent.toMaterialProp()
        )
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cardBackground,
        textStyle: TextStyle(color: cardForeground)
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: appBarBackground,
        foregroundColor: appBarForeground,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tertiaryTriad.base,
        focusColor: tertiaryAccent,
        hoverColor: tertiaryAccent
      )
    ).withCodeTheme(
      fontTheme.codeTheme
    )
  );
}

extension ColorButtonExtensions on Color {
  MaterialStateProperty<Color> toMaterialProp()
    => MaterialStateProperty.all(this);
}