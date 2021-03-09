import 'package:flutter/widgets.dart';

import '../app/fbf-app-config.dart';
import '../page/fbf-page-data.dart';

typedef FbfStatefulPageWidgetBuilder<C extends FbfAppConfig, D extends FbfPageData> =
  Widget Function(
    BuildContext context,
    C config,
    D pageData,
    StateSetter setState,
  );

class FbfStatefulPageBuilder<C extends FbfAppConfig,D extends FbfPageData>
  extends StatefulWidget {
  FbfStatefulPageBuilder({
    Key key, 
    @required this.builder
  }) :  assert(builder != null), 
        super(key: key);

  final FbfStatefulPageWidgetBuilder<C,D> builder;

  @override
  _FbfStatefulPageBuilderState<C,D> createState()
    => _FbfStatefulPageBuilderState<C,D>();
}

class _FbfStatefulPageBuilderState<C extends FbfAppConfig,D extends FbfPageData>
  extends State<FbfStatefulPageBuilder<C,D>> {
    @override
    Widget build(BuildContext context)
      => widget.builder(
        context,
        FbfAppConfig.of<C>(context),
        FbfPageData.of<D>(context),
        setState
      );
  }
