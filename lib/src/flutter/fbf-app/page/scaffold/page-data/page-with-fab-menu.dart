import 'package:flutter/material.dart';

import '../parts/fbf-fab-menu.dart';

abstract class FbfPageWithFabMenu {
  FabMenuConfig get fabMenuConfig;
}

class FabMenuConfig {
  FabMenuConfig({
    this.title,
    this.titleIcon,
    this.onSelect,
    this.menuItems,
    this.fabIcon,
  });

  final IconData fabIcon;
  final String title;
  final IconData titleIcon;
  final Function(String) onSelect;
  final List<FbfFabMenuItem> menuItems;
}
