import 'package:flutter/material.dart';

import '../../../app.dart';

typedef FbfFabMenuItemBuilder
  = FbfFabMenuItem Function(String item);

class FbfFabMenu<C extends FbfAppConfig> extends StatelessWidget {
  FbfFabMenu({
    this.title,
    this.titleIcon,
    this.titleColor,
    this.titleBackgroundColor,
    this.items,
    this.onSelect
  });

  final String title;
  final List<FbfFabMenuItem> items;
  final Function(String) onSelect;
  final Color titleColor;
  final Color titleBackgroundColor;
  final Widget titleIcon;

  @override
  Widget build(BuildContext context) {
    return FbfAppBuilder<C>(
      builder: (context, config) => Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: titleIcon,
              tileColor: config.theme.focusTriad.dark,
              title: Text( title,
                style: TextStyle(
                  color: titleColor ?? config.theme.secondaryAccent
                )
              )
            ),

            Divider(),

            ...items.map(
              (item) {
                return ListTile(
                  leading: item.icon,
                  title: Text(item.title),
                  subtitle: item.subtitle == null ? null : Text(item.subtitle),
                  onTap: () {
                    onSelect?.call(item.value);
                    Navigator.pop(context);
                  }
                );
              }
            ).toList()
          ],
        )
      )
    );
  }

  static void showBottomSheet<C extends FbfAppConfig>({BuildContext context,
    String title,
    Widget titleIcon,
    Color titleColor,
    Color titleBackgroundColor,
    List<FbfFabMenuItem> items,
    Function(String) onSelect,
  }) {
    final theme = FbfAppConfig.of<C>(context).theme;
    
    showModalBottomSheet<void>(
      backgroundColor: theme.cardBackground,
      context: context,
      builder: (context) => FbfFabMenu<C>(
        title: title,
        titleIcon: titleIcon,
        titleColor: titleColor ?? theme.onPrimary,
        titleBackgroundColor: titleBackgroundColor ?? theme.primaryBackground,
        items: items,
        onSelect: onSelect, 
      )
    );
  }
}

class FbfFabMenuItem {
  FbfFabMenuItem({this.value, this.icon, this.title, this.subtitle});

  final String value;
  final Widget icon;
  final String title;
  final String subtitle;
}
