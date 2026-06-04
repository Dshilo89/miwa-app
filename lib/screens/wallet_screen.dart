import 'package:flutter/material.dart';

/// Wallet screen
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wallet')),
      body: const Center(child: Text('Wallet Screen')),
    );
  }
}
