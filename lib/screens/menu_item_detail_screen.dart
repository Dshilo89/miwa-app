import 'package:flutter/material.dart';

/// Menu item detail screen
class MenuItemDetailScreen extends StatelessWidget {
  final String menuItemId;
  const MenuItemDetailScreen({super.key, required this.menuItemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meal Details')),
      body: Center(child: Text('Menu Item $menuItemId')),
    );
  }
}
