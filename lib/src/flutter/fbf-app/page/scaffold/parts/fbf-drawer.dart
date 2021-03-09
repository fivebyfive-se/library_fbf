import 'package:flutter/material.dart';

import '../../../../color.dart';
import '../../../app.dart';

class FbfDrawer<C extends FbfAppConfig> extends StatelessWidget {
  FbfDrawer({this.items});

  final List<FbfDrawerItem> items;

  Widget _buildTile(
    C fbfApp,
    String title, 
    String subtitle, 
    IconData icon, 
    Color color,
    [void Function() onTap]
  )
    => ListTile(
        trailing: icon == null ? null
          : Icon(
              icon, 
              size: fbfApp.size(4),
              color: color ?? fbfApp.theme.primaryAccent),
        title: Text(title, style: TextStyle(color: color)),
        subtitle: subtitle == null ? null
          : Text(subtitle),
        shape: RoundedRectangleBorder(side: BorderSide.none),
        onTap: onTap,
      );

  Widget _buildItem(BuildContext context, FbfDrawerItem item) {
    final fbfApp = FbfAppConfig.of<C>(context);
    
    if (item is FbfDrawerHeader) {
      return DrawerHeader(
        padding: fbfApp.edge.only(top: 2, bottom: 3),
        decoration: fbfApp.theme.logoBackgroundGradient.toDeco(),
        child: item.logo
      );
    } else if (item is FbfDrawerSubheading) {
      return _buildTile(
        fbfApp,
        item.title,
        item.subtitle,
        item.icon,
        item.color ?? fbfApp.theme.foreground
      );
    } else if (item is FbfDrawerNavigationLink) {
      final currentRoute = ModalRoute.of(context).settings.name;
      return _buildTile(
        fbfApp,
        item.title,
        item.subtitle,
        item.icon,
        currentRoute == item.pageRoute 
          ? fbfApp.theme.primaryAccent
          : fbfApp.theme.foreground,
        () {
          Navigator.of(context).pushReplacementNamed(item.pageRoute);
        }
      );
    } else if (item is FbfDrawerUrlLink) {
      return _buildTile(
        fbfApp,
        item.title,
        item.subtitle,
        item.icon,
        fbfApp.theme.foreground,
        item.onTap
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final fbfApp = FbfAppConfig.of<C>(context);
    final currentRoute = ModalRoute.of(context).settings.name;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: fbfApp.theme.drawerBackgroundGradient
        ),
        child: ListView(
          children: <Widget>[
            ...items.map((item) => _buildItem(context, item)).toList()
          ]
        )
      ),
    );
  }
}
enum FbfDrawerItemType {
  header,
  subheading,
  navigationLink,
  urlLink
}

abstract class FbfDrawerItem {
  FbfDrawerItem(this.type);
  final FbfDrawerItemType type;
}

class FbfDrawerHeader extends FbfDrawerItem {
  FbfDrawerHeader({this.logo}) : super(FbfDrawerItemType.header);
  final Widget logo;
}

abstract class FbfDrawerTextItem extends FbfDrawerItem {
  FbfDrawerTextItem(
    FbfDrawerItemType type,
    this.title,
    this.subtitle,
    this.icon,
    this.color,
  )
    : super(type);

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class FbfDrawerSubheading extends FbfDrawerTextItem {
  FbfDrawerSubheading({
    String title,
    String subtitle,
    IconData icon,
    Color color
  })
    : super(
        FbfDrawerItemType.subheading,
        title, subtitle, icon, color
    );

  
}

class FbfDrawerNavigationLink extends FbfDrawerTextItem {
  FbfDrawerNavigationLink({
    String title,
    String subtitle,
    IconData icon,
    Color color,
    this.pageRoute,
  })
    : super(
        FbfDrawerItemType.navigationLink,
        title, subtitle, icon, color
    );

    final String pageRoute;
}

class FbfDrawerUrlLink extends FbfDrawerTextItem {
  FbfDrawerUrlLink({
    String title,
    String subtitle,
    IconData icon,
    Color color,
    this.url,
    this.onTap,
  })
    : super(
        FbfDrawerItemType.urlLink,
        title, subtitle, icon, color
    );

    final String url;
    final void Function() onTap;
}
