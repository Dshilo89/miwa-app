import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_theme.dart';
import '../routes/app_router.dart';

/// Orders screen
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 80, color: AppTheme.textHint),
            const SizedBox(height: 16),
            const Text('No orders yet', style: TextStyle(fontSize: 18, color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            const Text('Your orders will appear here', style: TextStyle(color: AppTheme.textHint)),
          ],
        ),
      ),
    );
  }
}