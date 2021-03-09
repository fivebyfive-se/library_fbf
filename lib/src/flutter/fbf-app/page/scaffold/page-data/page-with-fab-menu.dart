import 'package:flutter/material.dart';

import '../parts/fbf-fab-menu.dart';

abstract class FbfPageWithFabMenu<T> {
  FabMenuConfig<T> get fabMenuConfig;
}

class FabMenuConfig<T> {
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
  final Function(T) onSelect;
  final List<FbfFabMenuItem<T>> menuItems;
}

