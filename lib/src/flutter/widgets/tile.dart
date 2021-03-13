import 'package:flutter/material.dart';

import '../fbf-app.dart';
import '../color.dart';

class FbfTile<C extends FbfAppConfig> extends StatelessWidget {
  FbfTile({
    this.icon,
    this.title,
    this.subtitle = '',
    this.onTap,
    this.foreground,
    this.background
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Function() onTap;
  final Color foreground;
  final Color background;

  static Widget heading<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => ListTile(
      leading: icon == null ? null : Icon(icon),
      title: Text(title, style: fbf.theme.fontTheme.textTheme.subtitle1),
      subtitle: Text(subtitle ?? '', style: fbf.theme.fontTheme.textTheme.subtitle2),
    )
  );

  static Widget action<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle = '',
    Function() onTap
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => FbfTile<C>(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      foreground: fbf.theme.primaryAccent,
    )
  );

  static Widget choice<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle = '',
    Function() onTap,
    bool selected
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => FbfTile<C>(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      foreground: selected ? fbf.theme.foreground : fbf.theme.cardForeground,
      background: selected ? fbf.theme.secondaryAccent : fbf.theme.cardBackground,
    )
  );

  static Widget danger<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle = '',
    Function() onTap
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => FbfTile<C>(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      foreground: fbf.theme.tertiaryAccent,
    )
  );

  static Widget info<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle = '',
    Function() onTap
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => FbfTile<C>(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      foreground: fbf.theme.highlight,
    )
  );

  static Widget checkbox<C extends FbfAppConfig>({
    IconData icon,
    String title,
    String subtitle = '',
    bool value,
    Function(bool) onChange,
  }) => FbfAppBuilder<C>(
    builder: (context, fbf) => CheckboxListTile(
      value: value,
      onChanged: onChange,
      title: Text(title),
      subtitle: Text(subtitle),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: fbf.theme.secondaryAccent,
      tileColor: fbf.theme.cardBackground,
      selectedTileColor: fbf.theme.cardBackground.deltaLightness(33),
    ));

  @override
  Widget build(BuildContext context) {
    return FbfAppBuilder<C>(
      builder: (context, fbf)
      => fbf == null ? null : ListTile(
          leading: icon == null ? null : Icon(
            icon,
            color: foreground  ?? fbf.theme.cardForeground
          ),
          title: Text(title),
          subtitle: Text(subtitle ?? ''),
          onTap: onTap,
          tileColor: background ?? fbf.theme.cardBackground,
        )
    );
  }
}