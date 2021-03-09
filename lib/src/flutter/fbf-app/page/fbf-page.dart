import 'package:flutter/material.dart';

import '../../../dart/uuid/uuid.dart';

import '../app/fbf-app-config.dart';

import 'fbf-page-data.dart';

abstract class FbfPage<D extends FbfPageData> extends StatefulWidget {
  FbfPage() : uuid = Uuid.v4();

  final String uuid;
}


extension FbfPageStateExtensions on State<FbfPage> {
  FbfAppConfig get appConfig => FbfAppConfig.of(context);
  FbfPageData get pageData => FbfPageData.of(context);

  Size get viewportSize => MediaQuery.of(context).size;
}