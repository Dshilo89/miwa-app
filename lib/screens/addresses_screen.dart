import 'package:flutter/material.dart';

/// Addresses screen
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: const Center(child: Text('Addresses Screen')),
    );
  }
}
