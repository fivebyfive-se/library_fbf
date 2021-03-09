import 'package:flutter/material.dart';

class FbfPageRoute {
  FbfPageRoute({
    @required this.routeName,
    @required this.builder,
  }) : assert(routeName != null),
       assert(builder != null);

  final String routeName;
  final WidgetBuilder builder;

  MapEntry<String, WidgetBuilder> toEntry()
    => MapEntry(routeName, builder);
}