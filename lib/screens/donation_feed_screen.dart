import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../themes/app_theme.dart';
import '../providers/donation_provider.dart';
import '../utils/app_utils.dart';
import '../routes/app_router.dart';

/// Live Donation Feed Screen - shows real-time social donation activity
class DonationFeedScreen extends StatefulWidget {
  const DonationFeedScreen({super.key});

  @override
  State<DonationFeedScreen> createState() => _DonationFeedScreenState();
}

class _DonationFeedScreenState extends State<DonationFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DonationProvider>().initFeedStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💚 Live Donations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => context.push('/home/donation'),
            tooltip: 'Donate Now',
          ),
        ],
      ),
      body: Consumer<DonationProvider>(
        builder: (context, donationProvider, _) {
          return Column(
            children: [
              // Impact Stats
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppTheme.greenGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('🤝 Community Impact', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('Total Meals', '${donationProvider.donationFeed.fold(0, (sum, d) => sum + d.mealCount)}'),
                        _buildStat('Donors', '${donationProvider.donationFeed.length}'),
                        _buildStat('Campaigns', '${donationProvider.campaigns.length}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/home/donation'),
                        icon: const Icon(Icons.favorite),
                        label: const Text('Donate Now'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),

              // Live Feed Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 10, height: 10,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppTheme.success),
                    ),
                    const SizedBox(width: 8),
                    const Text('Live Donation Feed', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const Spacer(),
                    Text('${donationProvider.donationFeed.length} donations',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Donation Feed List
              Expanded(
                child: donationProvider.donationFeed.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_border, size: 60, color: AppTheme.textHint),
                            SizedBox(height: 16),
                            Text('No donations yet', style: TextStyle(color: AppTheme.textHint, fontSize: 16)),
                            SizedBox(height: 8),
                            Text('Be the first to make an impact!', style: TextStyle(color: AppTheme.textSecondary)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: donationProvider.donationFeed.length,
                        itemBuilder: (context, index) {
                          final donation = donationProvider.donationFeed[index];
                          return _buildDonationItem(donation);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildDonationItem(dynamic donation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: donation.isAnonymous
              ? AppTheme.textHint
              : AppUtils.colorFromString(donation.userName ?? ''),
          child: Text(
            donation.isAnonymous ? '?' : AppUtils.getInitials(donation.userName ?? ''),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        title: Text(
          donation.feedText,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Row(
          children: [
            if (donation.isCorporate)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('Sponsored', style: TextStyle(fontSize: 10, color: AppTheme.primaryOrange)),
              ),
            Text(AppUtils.timeAgo(donation.createdAt), style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
        trailing: Icon(
          donation.type == 'meal' ? Icons.restaurant : Icons.monetization_on,
          color: donation.type == 'meal' ? AppTheme.primaryGreen : AppTheme.accentYellow,
        ),
      ),
    );
  }
}