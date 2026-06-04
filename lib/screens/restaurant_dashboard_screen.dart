import 'package:flutter/material.dart';

/// Restaurant owner dashboard screen
class RestaurantDashboardScreen extends StatelessWidget {
  const RestaurantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Dashboard')),
      body: const Center(child: Text('Restaurant Owner Dashboard')),
    );
  }
}
