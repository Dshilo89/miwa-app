import 'package:flutter/material.dart';

/// Rider dashboard screen
class RiderDashboardScreen extends StatelessWidget {
  const RiderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rider Dashboard')),
      body: const Center(child: Text('Rider App Dashboard')),
    );
  }
}
