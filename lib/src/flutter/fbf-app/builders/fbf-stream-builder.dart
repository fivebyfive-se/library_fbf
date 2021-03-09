import 'package:flutter/material.dart';

import '../app/fbf-app-config.dart';

typedef FbfStreamWidgetBuilder<C extends FbfAppConfig,S> =
  Widget Function(BuildContext context, C config, S snapshot);

class FbfStreamBuilder<C extends FbfAppConfig,S> extends StatefulWidget {
  FbfStreamBuilder({
    Key key,
    this.stream,
    this.initialData,
    this.builder
  }) :  assert(stream != null),
        assert(builder != null),
        super(key: key);

  final Stream<S> stream;
  final S initialData;
  final FbfStreamWidgetBuilder<C,S> builder;

  @override
  _FbfStreamBuilderState<C,S> createState()
    => _FbfStreamBuilderState<C,S>();
}

class _FbfStreamBuilderState<C extends FbfAppConfig,S>
extends State<FbfStreamBuilder<C,S>> {
  @override
  Widget build(BuildContext context)
    => StreamBuilder<S>(
      stream: widget.stream,
      initialData: widget.initialData,
      builder: (context, snapshot) 
        => widget.builder(
            context,
            FbfAppConfig.of<C>(context),
            snapshot.data
          )
    );
}