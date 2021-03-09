import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'fbf-app-container.dart';
import '../theme.dart';
import '../routing.dart';

class FbfAppConfig<T extends FbfTheme, R extends FbfPageRouteList> {
  const FbfAppConfig({
    this.appName,
    this.routes,
    this.theme,
  })
    : assert(theme != null),
      assert(routes != null);

  final String appName;
  final T theme;
  final R routes;

  FbfPageRouteList get pages => routes;
  ThemeData        get themeData => theme.themeData;
  FbfFontTheme     get fontTheme => theme.fontTheme;
  TextTheme        get textTheme => fontTheme.textTheme;
  FbfCodeTheme     get codeTheme => fontTheme.codeTheme;
  FbfLayoutTheme   get layoutTheme => theme.layoutTheme;
  
  FbfLayoutBorder  get border => layoutTheme.border;
  FbfLayoutEdge    get edge   => layoutTheme.edgeInsets;

  double get baseSize => layoutTheme.baseSize;
  double get baseBorderWidth => layoutTheme.baseBorderWidth;

  double size([double f = 1.0])        => layoutTheme.size(f);
  double borderWidth([double f = 1.0]) => layoutTheme.borderWidth(f);

  @override
  int get hashCode => hashValues(theme, routes);

  @override
  bool operator ==(Object other)
    => identical(this, other) || (
      other.runtimeType == runtimeType
        && other is FbfAppConfig<T,R>
        && other.theme == theme
        && other.routes == routes
    );

  static C of<C extends FbfAppConfig>(BuildContext context)
    => FbfAppContainer.of<FbfAppContainer<C>>(context)?.config;
}