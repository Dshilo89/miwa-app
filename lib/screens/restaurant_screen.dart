import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../themes/app_theme.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../models/restaurant_model.dart';
import '../models/menu_item_model.dart';
import '../models/user_model.dart';
import '../utils/app_utils.dart';
import '../widgets/app_shimmer.dart';

/// Restaurant details screen with categories, menu listing, add-to-cart, and reviews
class RestaurantScreen extends StatefulWidget {
  final String restaurantId;
  const RestaurantScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RestaurantProvider>();
      provider.loadMenuItems(widget.restaurantId);
      // Ensure we find the selected restaurant in case it's not pre-selected
      if (provider.selectedRestaurant?.id != widget.restaurantId) {
        final rest = provider.restaurants.firstWhere(
          (r) => r.id == widget.restaurantId,
          orElse: () => Restaurant(
            id: widget.restaurantId,
            name: 'MIWA Kitchen',
            phone: '08123456789',
            email: 'kitchen@miwa.com',
            address: Address(id: '1', label: 'Address', street: '123 MIWA Way', latitude: 6.5244, longitude: 3.3792),
            cuisineTypes: ['Local', 'African', 'Rice', 'Soups'],
            rating: 4.8,
            totalReviews: 124,
            deliveryFee: 500,
            minimumOrder: 1000,
            isOpen: true,
            isVerified: true,
            acceptsDonations: true,
          ),
        );
        provider.selectRestaurant(rest);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = context.watch<RestaurantProvider>();
    final cartProvider = context.watch<CartProvider>();
    final restaurant = restaurantProvider.selectedRestaurant;

    if (restaurant == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Get unique categories from menu items
    final categories = ['All', ...Set<String>.from(restaurantProvider.menuItems.map((item) => item.categoryId))];

    // Filter menu items
    final filteredItems = _selectedCategory == 'All'
        ? restaurantProvider.menuItems
        : restaurantProvider.menuItems.where((item) => item.categoryId == _selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Banner Image & App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppTheme.primaryOrange,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                restaurant.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  restaurant.coverPhotoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: restaurant.coverPhotoUrl!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppTheme.primaryOrange, AppTheme.primaryGreen],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Restaurant Header Information
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: restaurant.cuisineTypes
                            .map((type) => Chip(
                                  label: Text(type, style: const TextStyle(fontSize: 11)),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ))
                            .toList(),
                      ),
                      if (restaurant.acceptsDonations)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, color: AppTheme.primaryGreen, size: 14),
                              SizedBox(width: 4),
                              Text('Donation Partner', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.accentYellow, size: 20),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 4),
                      Text('(${restaurant.totalReviews} reviews)', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      const Spacer(),
                      const Icon(Icons.access_time, color: AppTheme.textHint, size: 18),
                      const SizedBox(width: 4),
                      Text('${restaurant.preparationTime} mins prep', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining, color: AppTheme.primaryOrange, size: 20),
                      const SizedBox(width: 4),
                      Text(AppUtils.formatCurrency(restaurant.deliveryFee), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.shopping_bag_outlined, color: AppTheme.textHint, size: 18),
                      const SizedBox(width: 4),
                      Text('Min: ${AppUtils.formatCurrency(restaurant.minimumOrder)}', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    restaurant.description ?? 'A premium MIWA restaurant supporting community feeding programs and delicious meals.',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
                  ),
                  const Divider(height: 32),
                ],
              ),
            ),
          ),

          // Tab Bar (Menu Items / Reviews)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.primaryOrange,
                labelColor: AppTheme.primaryOrange,
                unselectedLabelColor: AppTheme.textSecondary,
                tabs: const [
                  Tab(text: 'Menu'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),

          // Menu / Reviews Switcher
          SliverToBoxAdapter(
            child: SizedBox(
              height: 600, // Safe bounds for our content inside CustomScrollView
              child: TabBarView(
                controller: _tabController,
                children: [
                  // MENU TAB
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category horizontal list filter
                      if (categories.length > 1)
                        Container(
                          height: 45,
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final cat = categories[index];
                              final isSelected = _selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(cat == 'All' ? 'All Items' : cat.toUpperCase()),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() => _selectedCategory = cat);
                                    }
                                  },
                                  selectedColor: AppTheme.primaryOrange.withOpacity(0.15),
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppTheme.primaryOrange : AppTheme.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      // Menu Items list
                      Expanded(
                        child: restaurantProvider.isLoading
                            ? ListView.builder(
                                itemCount: 3,
                                itemBuilder: (context, index) => AppShimmer.restaurantCard(),
                              )
                            : filteredItems.isEmpty
                                ? const Center(child: Text('No menu items available in this category'))
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: filteredItems.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];
                                      return _buildMenuItemTile(item, cartProvider);
                                    },
                                  ),
                      ),
                    ],
                  ),

                  // REVIEWS TAB
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 4, // Simulated reviews count
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        color: AppTheme.backgroundLight,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                                    child: const Text('U', style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sarah James', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text('2 days ago', style: TextStyle(fontSize: 10, color: AppTheme.textHint)),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 14,
                                        color: i < 4 ? AppTheme.accentYellow : AppTheme.textHint,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'The food was absolutely fantastic! Clean package, highly recommended. Love that they also sponsor charity meals.',
                                style: TextStyle(fontSize: 12, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemTile(MenuItem item, CartProvider cartProvider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
                child: item.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => const Icon(Icons.fastfood, color: AppTheme.primaryOrange),
                      )
                    : Container(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        child: const Icon(Icons.fastfood, color: AppTheme.primaryOrange),
                      ),
              ),
            ),
            const SizedBox(width: 12),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description ?? 'Delectable premium recipe, prepared fresh.',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        AppUtils.formatCurrency(item.price),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primaryOrange),
                      ),
                      if (item.isDonationEligible) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.favorite, color: AppTheme.primaryGreen, size: 10),
                              SizedBox(width: 2),
                              Text('Charity Eligible', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 9, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Add button
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      cartProvider.addItem(item);
                      AppUtils.showSuccessSnackbar(context, '${item.name} added to cart');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: AppTheme.primaryOrange,
                    ),
                    child: const Text('Add', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
