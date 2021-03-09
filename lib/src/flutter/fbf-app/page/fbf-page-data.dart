import 'package:flutter/widgets.dart';

import '../../../dart/uuid/uuid.dart';
import 'fbf-page-container.dart';

abstract class FbfPageData {
  FbfPageData({this.pageRoute, this.pageTitle})
    : id = Uuid.v4();

  final String id;
  final String pageRoute;
  final String pageTitle;

  static D of<D extends FbfPageData>(BuildContext context)
    => FbfPageContainer.of<FbfPageContainer<D>>(context)?.pageData;
}
