import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../themes/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_utils.dart';

/// Cart screen with full calculations, coupon code entries, tipping riders, and donation integrations
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _couponController = TextEditingController();
  double _selectedTip = 0.0;
  double _selectedDonation = 0.0;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final authProvider = context.watch<AuthProvider>();

    // Mock Delivery calculation
    if (cartProvider.deliveryFee == 0.0 && !cartProvider.isEmpty) {
      cartProvider.setDeliveryFee(500.0);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Basket'),
        centerTitle: true,
        actions: [
          if (!cartProvider.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.error),
              onPressed: () {
                cartProvider.clearCart();
                AppUtils.showSuccessSnackbar(context, 'Basket cleared');
              },
            ),
        ],
      ),
      body: cartProvider.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Your basket is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Add items from restaurants to start', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange),
                    child: const Text('Browse Restaurants'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Header
                  if (cartProvider.restaurantName != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.storefront, color: AppTheme.primaryOrange),
                        const SizedBox(width: 8),
                        Text(
                          cartProvider.restaurantName!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Basket items
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProvider.itemList.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.itemList[index];
                      final key = cartProvider.items.keys.elementAt(index);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: item.imageUrl != null
                                      ? CachedNetworkImage(imageUrl: item.imageUrl!, fit: BoxFit.cover)
                                      : Container(color: Colors.grey[200], child: const Icon(Icons.fastfood, color: AppTheme.primaryOrange)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 4),
                                    Text(AppUtils.formatCurrency(item.price), style: const TextStyle(color: AppTheme.primaryOrange, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              // Counter
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    onPressed: () => cartProvider.updateQuantity(key, item.quantity - 1),
                                  ),
                                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20),
                                    onPressed: () => cartProvider.updateQuantity(key, item.quantity + 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Coupon section
                  const Text('Do you have a coupon?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: InputDecoration(
                            hintText: 'Enter coupon code',
                            fillColor: AppTheme.backgroundLight,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (_couponController.text.toUpperCase() == 'MIWA50') {
                            cartProvider.applyCoupon('MIWA50', 500.0);
                            AppUtils.showSuccessSnackbar(context, 'Coupon MIWA50 applied (₦500 off)');
                          } else {
                            AppUtils.showErrorSnackbar(context, 'Invalid coupon code');
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryOrange),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Donate Meals / Sponsored charity section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.favorite, color: AppTheme.primaryGreen),
                            SizedBox(width: 8),
                            Text('Sponsor a Charity Meal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primaryGreen)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Help us feed people in need. Add a donation meal to your order for only ₦500. Denshi Global Services matching your donation today!',
                          style: TextStyle(fontSize: 12, height: 1.4, color: AppTheme.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [0, 500, 1000, 2000].map((amount) {
                            final isSelected = _selectedDonation == amount;
                            return ChoiceChip(
                              label: Text(amount == 0 ? 'None' : '+₦$amount'),
                              selected: isSelected,
                              selectedColor: AppTheme.primaryGreen,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() => _selectedDonation = amount.toDouble());
                                  cartProvider.setDonation(amount.toDouble());
                                }
                              },
                            );
                          }).toList(),
                        ),
                        if (_selectedDonation > 0) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              AppUtils.getDonationSuggestion(_selectedDonation),
                              style: const TextStyle(fontSize: 12, color: AppTheme.primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tip Rider section
                  const Text('Tip Your Rider', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [0, 200, 500, 1000].map((tip) {
                      final isSelected = _selectedTip == tip;
                      return ChoiceChip(
                        label: Text(tip == 0 ? 'Not now' : '₦$tip'),
                        selected: isSelected,
                        selectedColor: AppTheme.primaryOrange,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedTip = tip.toDouble());
                            cartProvider.setTip(tip.toDouble());
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Order Summary calculations
                  const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildSummaryRow('Subtotal', AppUtils.formatCurrency(cartProvider.subtotal)),
                          const Divider(),
                          _buildSummaryRow('Delivery Fee', AppUtils.formatCurrency(cartProvider.deliveryFee)),
                          const Divider(),
                          if (cartProvider.discount > 0) ...[
                            _buildSummaryRow('Discount (Coupon)', '-${AppUtils.formatCurrency(cartProvider.discount)}', textColor: AppTheme.error),
                            const Divider(),
                          ],
                          if (cartProvider.donationAmount > 0) ...[
                            _buildSummaryRow('Charity Donation', AppUtils.formatCurrency(cartProvider.donationAmount), textColor: AppTheme.primaryGreen),
                            const Divider(),
                          ],
                          if (cartProvider.tip > 0) ...[
                            _buildSummaryRow('Rider Tip', AppUtils.formatCurrency(cartProvider.tip)),
                            const Divider(),
                          ],
                          _buildSummaryRow('Total', AppUtils.formatCurrency(cartProvider.total), isTotal: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Checkout Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/home/checkout');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryOrange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
              color: textColor ?? (isTotal ? AppTheme.primaryOrange : AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
