import 'package:flutter/widgets.dart';

import '../fbf-app.dart';

Widget listToGrid<C extends FbfAppConfig>(
  List<Widget> list, {
    int crossAxisCount = 2,
    double crossAxisSpacing,
    double mainAxisExtent
})
  => FbfAppBuilder<C>(
    builder: (context, fbf) => SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing ?? fbf.size(4),
        mainAxisExtent: mainAxisExtent ?? fbf.size(10),        
      ),
      delegate: SliverChildListDelegate(list),
    )
  );


Widget listToList(
  List<Widget> list
) => SliverList(
    delegate: SliverChildListDelegate(list)
  );


Widget sliverSpacer<C extends FbfAppConfig>({double size})
  => FbfAppBuilder<C>(
      builder: (context, fbf) => SliverToBoxAdapter(
        child: Container(height: size ?? fbf.size(1))
    ));

