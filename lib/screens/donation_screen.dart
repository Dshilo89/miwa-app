import 'package:flutter/material.dart';

/// Donation screen
class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate Meals')),
      body: const Center(child: Text('Donation Screen')),
    );
  }
}
