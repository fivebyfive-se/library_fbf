import 'package:flutter/material.dart';
import '_page-route-base.dart';

class FbfPageRoute extends FbfPageRouteBase {
  FbfPageRoute({
    String routeName,
    this.builder,
  }) :  super(routeName);

  final WidgetBuilder builder;

  MapEntry<String, WidgetBuilder> toEntry()
    => MapEntry(routeName, builder);
}