import 'package:fbf/src/flutter/fbf-app/page/scaffold/page-data/page-with-bottom-navigation.dart';
import 'package:fbf/src/flutter/fbf-app/page/scaffold/page-data/page-with-drawer.dart';
import 'package:flutter/material.dart';

import '../../app/fbf-app-config.dart';
import 'page-data/scaffold-off-mixins.dart';
import 'page-data/page-with-fab-menu.dart';

import '../fbf-page-data.dart';

import 'parts/fbf-bottom-nav-bar.dart';
import 'parts/fbf-drawer.dart';
import 'parts/fbf-fab-menu.dart';

typedef FbfScaffoldContentBuilder<C extends FbfAppConfig, D extends FbfPageData> =
  Widget Function(BuildContext context, C config, D pageData);

class FbfScaffold<C extends FbfAppConfig, D extends FbfPageData> extends StatelessWidget {
  FbfScaffold({this.context, this.pageData, this.builder});

  final BuildContext context;
  final FbfScaffoldContentBuilder<C,D> builder;
  final D pageData;

  C get appConfig => FbfAppConfig.of<C>(context);

  @override
  Widget build(BuildContext context)
    => (pageData is Scaffold_Off)
      ? builder(context, appConfig, pageData)
      : Scaffold(
          backgroundColor: appConfig.theme.background,
          primary: true,
          appBar: _scaffoldAppBar(),
          bottomNavigationBar: _scaffoldBottomNavigationBar(),
          drawer: _scaffoldDrawer(),
          floatingActionButton: _scaffoldFab(),
          floatingActionButtonLocation: 
            FloatingActionButtonLocation.centerDocked,
          body: builder(context, appConfig, pageData)
      );

  @protected
  Widget _scaffoldAppBar()
    => (pageData is Scaffold_AppBar_Off)
        ? null
        : AppBar(title: Text(pageData.pageTitle));

  @protected
  Widget _scaffoldBottomNavigationBar()
    => (pageData is FbfPageWithBottomNavigation)
      ? FbfBottomNavigation<C>(pages: (pageData as FbfPageWithBottomNavigation).pages)
      : null;

  @protected
  Widget _scaffoldDrawer()
    => (pageData is FbfPageWithDrawer)
      ? FbfDrawer<C>(items: (pageData as FbfPageWithDrawer).drawerItems)
      : null;

  @protected
  Widget _scaffoldFab() {
    if (pageData is FbfPageWithFabMenu) {
      final fab = pageData as FbfPageWithFabMenu;
      final fabMenuConf = fab.fabMenuConfig;

      return FloatingActionButton(
        backgroundColor: appConfig.theme.primaryAccent,
        child: Icon(fabMenuConf.fabIcon, color: appConfig.theme.background),

        onPressed: () => FbfFabMenu.showBottomSheet<C>(
          context: context,
          items: fabMenuConf.menuItems,
          title: fabMenuConf.title,
          titleIcon: Icon(fabMenuConf.titleIcon),
          onSelect: (v) => fabMenuConf.onSelect?.call(v)
        )
      );
    }
    return null;
  }
}