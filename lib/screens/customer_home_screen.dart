import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/restaurant_provider.dart';
import '../providers/donation_provider.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/campaign_card.dart';
import '../widgets/app_shimmer.dart';
import '../routes/app_router.dart';

/// Customer Home Screen - Main landing page for food delivery
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().loadRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('MIWA', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Deliver to: Lagos, Nigeria',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/home/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            InkWell(
              onTap: () => context.push('/home/search'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppTheme.textHint),
                    const SizedBox(width: 12),
                    const Text('Search restaurants or meals...',
                        style: TextStyle(color: AppTheme.textHint)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune, size: 18, color: AppTheme.primaryOrange),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Promotions Banner
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: AppTheme.orangeGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🍽️ Special Offer!',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Free delivery on your\nfirst 3 orders',
                            style: TextStyle(color: Colors.white.withOpacity(0.9))),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('Order Now', style: TextStyle(color: AppTheme.primaryOrange, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.restaurant_menu, size: 80, color: Colors.white24),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Categories
            const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(Icons.local_pizza_outlined, 'Pizza'),
                  _buildCategoryItem(Icons.lunch_dining, 'Burgers'),
                  _buildCategoryItem(Icons.local_drink, 'Drinks'),
                  _buildCategoryItem(Icons.cake_outlined, 'Desserts'),
                  _buildCategoryItem(Icons.rice_bowl, 'Rice'),
                  _buildCategoryItem(Icons.soup_kitchen, 'Soups'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Active Campaigns
            Consumer<DonationProvider>(
              builder: (context, donationProvider, _) {
                if (donationProvider.campaigns.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('💚 Community Campaigns',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        TextButton(
                          onPressed: () => context.push('/home/donation'),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 180,
                      child: donationProvider.isLoading 
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) => AppShimmer.campaignCard(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: donationProvider.campaigns.length,
                            itemBuilder: (context, index) {
                              return CampaignCard(campaign: donationProvider.campaigns[index]);
                            },
                          ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),

            // Nearby Restaurants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nearby Restaurants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 8),

            Consumer<RestaurantProvider>(
              builder: (context, restaurantProvider, _) {
                if (restaurantProvider.isLoading) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) => AppShimmer.restaurantCard(),
                  );
                }
                if (restaurantProvider.restaurants.isEmpty) {
                  return const Center(child: Text('No restaurants available'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurantProvider.restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurantProvider.restaurants[index];
                    return RestaurantCard(
                      restaurant: restaurant,
                      onTap: () => context.push('/home/restaurant/${restaurant.id}'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Icon(icon, color: AppTheme.primaryOrange, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}