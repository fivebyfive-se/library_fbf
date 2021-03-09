import 'package:flutter/material.dart';

import 'fbf-app-config.dart';
import '../page/fbf-page-data.dart';

typedef FbfAppWidgetBuilder<C extends FbfAppConfig> 
  = Widget Function(BuildContext context, C config);

class FbfAppBuilder<C extends FbfAppConfig> extends StatelessWidget {
  FbfAppBuilder({
    Key key,
    @required this.builder
  })
    : assert(builder != null),
      super(key: key);

  final FbfAppWidgetBuilder<C> builder;

  @override Widget build(BuildContext context)
    => builder(
      context,
      FbfAppConfig.of<C>(context)
    );
}
