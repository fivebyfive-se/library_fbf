import 'package:flutter/material.dart';

import '../fbf-app.dart';

class FbfBtn extends StatelessWidget {
  FbfBtn(this.label, {
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.baseSize = 2.0,
    this.style,
    this.width,
    this.height,
  }) : icon = null,
       iconColor = null;


  FbfBtn.icon(this.label, {
    this.icon,
    this.iconColor,
    this.onPressed,
    this.backgroundColor,
    this.borderColor,
    this.baseSize = 2.0,
    this.style,
    this.width,
    this.height,
  });

  final String label;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final double baseSize;
  final TextStyle style;
  final double width;
  final double height;

  final IconData icon;
  final Color iconColor;


  static Widget action(
    String label, {
    Function() onPressed,
    double baseSize = 2.0,
    TextStyle style,
    double width,
    double height,
    }
  ) => FbfAppBuilder<FbfAppConfig>(
          builder: (c, fbf) => FbfBtn(
            label, 
            onPressed: onPressed,
            backgroundColor: fbf.theme.primaryTriad.dark,
            style: style,
            width: width,
            height: height,
            baseSize: baseSize,
          )
  );

  static Widget choice(
    String label, {
    Function() onPressed,
    double baseSize = 2.0,
    TextStyle style,
    double width,
    double height,
    }
  ) => FbfAppBuilder<FbfAppConfig>(
          builder: (c, fbf) => FbfBtn(
            label, 
            onPressed: onPressed,
            backgroundColor: fbf.theme.secondaryTriad.dark,
            style: style,
            width: width,
            height: height,
            baseSize: baseSize,
          )
  );

  static Widget danger(
    String label, {
    Function() onPressed,
    double baseSize = 2.0,
    TextStyle style,
    double width,
    double height,
    }
  ) => FbfAppBuilder<FbfAppConfig>(
          builder: (c, fbf) => FbfBtn(
            label, 
            onPressed: onPressed,
            backgroundColor: fbf.theme.tertiaryTriad.dark,
            style: style,
            width: width,
            height: height,
            baseSize: baseSize,
          )
  );

  MaterialStateProperty<T> _p<T>(T val)
    => MaterialStateProperty.all(val);

  ButtonStyle _style(FbfAppConfig fbf) 
    => ButtonStyle(
    padding: _p(fbf.edge.xy(baseSize, baseSize / 2)),
    side: _p(BorderSide(
      color: borderColor ?? backgroundColor,
      width: fbf.baseBorderWidth
    )),
    backgroundColor: _p(backgroundColor ?? fbf.theme.primaryAccent),
    
    minimumSize: _p(Size(width ?? 200, height ?? 50)),
  );

  Widget _t(FbfAppConfig fbf)
    => Text(label, style: fbf.textTheme.subtitle1.merge(style));

  @override
  Widget build(BuildContext context) {
    return FbfAppBuilder<FbfAppConfig>(
      builder: (context, fbf)
        => icon == null 
          ? ElevatedButton(
              onPressed: onPressed,
              child: _t(fbf),
              style: _style(fbf)
            )
          : ElevatedButton.icon(
              icon: Icon(icon, color: iconColor),
              onPressed: onPressed,
              label: _t(fbf),
              style: _style(fbf)
          )
    );
  }
}
