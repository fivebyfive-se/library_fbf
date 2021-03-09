import 'package:flutter/material.dart';

import '../../../app.dart';
import '../page-data/scaffold-off-mixins.dart';

typedef FbfFabMenuItemBuilder<T>
  = FbfFabMenuItem<T> Function(T item);

class FbfFabMenu<T,C extends FbfAppConfig> extends StatelessWidget {
  FbfFabMenu({
    this.title,
    this.titleIcon,
    this.titleColor,
    this.titleBackgroundColor,
    this.items,
    this.onSelect
  });

  final String title;
  final List<FbfFabMenuItem<T>> items;
  final Function(T) onSelect;
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

  static void showBottomSheet<X,C extends FbfAppConfig>({BuildContext context,
    String title,
    Widget titleIcon,
    Color titleColor,
    Color titleBackgroundColor,
    List<FbfFabMenuItem<X>> items,
    Function(X) onSelect,
  }) {
    showModalBottomSheet<void>(
      backgroundColor: FbfAppConfig.of<C>(context).theme.cardBackground,
      context: context,
      builder: (context) => FbfFabMenu<X,C>(
        title: title,
        titleIcon: titleIcon,
        titleColor: titleColor,
        titleBackgroundColor: titleBackgroundColor,
        items: items,
        onSelect: onSelect, 
      )
    );
  }
}

class FbfFabMenuItem<T> {
  FbfFabMenuItem({this.value, this.icon, this.title, this.subtitle});

  final T value;
  final Widget icon;
  final String title;
  final String subtitle;
}
