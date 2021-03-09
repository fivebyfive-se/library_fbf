import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'fbf-app-builder.dart';
import 'fbf-app-container.dart';
import 'fbf-app-config.dart';

class FbfApp<C extends FbfAppConfig> extends StatelessWidget {
  FbfApp({this.config});

  final C config;

  @override
  Widget build(BuildContext context)
    => FbfAppContainer(
      config: config,
      child: FbfAppBuilder<C>(
        builder: (ctx, cfg) => MaterialApp(
          title: cfg.appName,
          theme: cfg.theme.themeData,
          routes: cfg.routes.routes,
          initialRoute: cfg.routes.initialRoute,
        )
      )
    );
}

