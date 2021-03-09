import 'package:flutter/material.dart';

import '../app/fbf-app-config.dart';
import '../page/fbf-page-data.dart';

typedef FbfStatefulWidgetBuilder<C extends FbfAppConfig> =
  Widget Function(
    BuildContext context,
    C config,
    StateSetter setState,
  );

class FbfStatefulBuilder<C extends FbfAppConfig> extends StatefulWidget {
  FbfStatefulBuilder({
    Key key, 
    @required this.builder
  }) :  assert(builder != null), 
        super(key: key);

  final FbfStatefulWidgetBuilder<C> builder;

  @override
  _FbfStatefulBuilderState<C> createState()
    => _FbfStatefulBuilderState<C>();
}

class _FbfStatefulBuilderState<C extends FbfAppConfig>
                                  extends State<FbfStatefulBuilder<C>> {
  @override
  Widget build(BuildContext context)
    => widget.builder(
      context,
      FbfAppConfig.of<C>(context),
      setState
    );
}