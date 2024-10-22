// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum DrawerOption {
  profile('Profile'),
  orders('Orders');

  const DrawerOption(this.name);

  final String name;
}

List<NavBarItem> mainNavigationBarItems({
  required String homeLabel,
  required String cartLabel,
}) =>
    <NavBarItem>[
      NavBarItem(icon: LucideIcons.chefHat, label: homeLabel),
      NavBarItem(icon: LucideIcons.shoppingCart, label: cartLabel),
    ];


class NavBarItem {

  NavBarItem({
    this.icon,
    this.label,
    this.child,
  });
  
  final String? label;
  final Widget? child;
  final IconData? icon;

  String? get tooltip => label;
}
