import 'package:flutter/material.dart';

import 'fbf-app-config.dart';

class FbfAppContainer extends InheritedWidget {
  const FbfAppContainer({
    Key key,
    @required this.config,
    @required Widget child
  }) : assert(config != null),
       assert(child != null),
       super(key: key, child: child);

  final FbfAppConfig config;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is FbfAppContainer) {
      return config != oldWidget.config;
    }
    return true;
  }

  static S of<S extends FbfAppContainer>(BuildContext context)
    => context.dependOnInheritedWidgetOfExactType<S>();
}
