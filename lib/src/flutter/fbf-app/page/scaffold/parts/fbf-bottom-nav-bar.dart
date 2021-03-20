import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../theme.dart';

class FbfBottomNavigation<C extends FbfAppConfig> extends StatefulWidget {
  FbfBottomNavigation({this.pages});

  final List<FbfBottomNavigationPage> pages;

  @override
  _FbfBottomNavigationState<C> createState() => _FbfBottomNavigationState<C>();
}

class _FbfBottomNavigationState<C extends FbfAppConfig> extends State<FbfBottomNavigation<C>> {
  List<FbfBottomNavigationPage> get _pages => widget.pages;
  FbfTheme get _theme => FbfAppConfig.of<C>(context).theme;

  BottomNavigationBarItem _pageToItem(FbfBottomNavigationPage p) 
    => BottomNavigationBarItem(
      icon: Icon(
        p.disabled
          ? p.disabledIcon
          : p.icon,
        color: p.disabled 
          ? _theme.bottomNavDisabled
          : _theme.bottomNavForeground
      ),
      activeIcon: Icon(p.activeIcon),
      label: p.disabled ? "" : p.label,
      tooltip: p.label
    );

  void _onItemTapped(int index) {
    if (!_pages[index].disabled) {
      Navigator.pushNamed(context, _pages[index].routeName);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context).settings.name;
    final currentIndex = _pages.indexWhere((p) => p.routeName == currentRoute);

    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      backgroundColor: _theme.bottomNavBackground,
      unselectedItemColor: _theme.bottomNavForeground,
      selectedItemColor: _theme.bottomNavSelected,
      onTap: _onItemTapped,
      items: _pages.map((p) => _pageToItem(p)).toList()
    );
  }
}

class FbfBottomNavigationPage {
  FbfBottomNavigationPage({
    this.disabled = false,
    this.label,
    this.icon,
    this.routeName,
    IconData activeIcon,
    IconData disabledIcon
  }) : activeIcon = activeIcon ?? icon,
       disabledIcon = disabledIcon ?? icon;

  final bool disabled;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final IconData disabledIcon;
  final String routeName;
}

class FbfBottomNavigationConfig {
  FbfBottomNavigationConfig({
    this.pages,
    this.activePageRoute
  });

  final List<FbfBottomNavigationPage> pages;
  final String activePageRoute;
}
