import 'package:flutter/material.dart';

import 'fbf-page-data.dart';

class FbfPageContainer<D extends FbfPageData> extends InheritedWidget {
  const FbfPageContainer({
    Key key,
    this.pageData,
    Widget child
  }) : super(key: key, child: child);

  final D pageData;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget)
    => (oldWidget is FbfPageContainer<D> && pageData.id != oldWidget.pageData.id);

  static S of<S extends FbfPageContainer>(BuildContext context)
    => context.dependOnInheritedWidgetOfExactType<S>();
}