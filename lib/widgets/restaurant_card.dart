import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/restaurant_model.dart';
import '../themes/app_theme.dart';
import '../utils/app_utils.dart';

/// Reusable restaurant card widget
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Restaurant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: restaurant.photoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: restaurant.photoUrl!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: Colors.grey[200]),
                          errorWidget: (_, __, ___) => Container(
                            color: AppTheme.primaryOrange.withOpacity(0.1),
                            child: const Icon(Icons.restaurant, color: AppTheme.primaryOrange),
                          ),
                        )
                      : Container(
                          color: AppTheme.primaryOrange.withOpacity(0.1),
                          child: const Icon(Icons.restaurant, color: AppTheme.primaryOrange),
                        ),
                ),
              ),
              const SizedBox(width: 12),

              // Restaurant Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (restaurant.isOpen)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Open', style: TextStyle(fontSize: 11, color: AppTheme.success, fontWeight: FontWeight.w500)),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Closed', style: TextStyle(fontSize: 11, color: AppTheme.error)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      restaurant.cuisineTypes.take(3).join(' • '),
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: AppTheme.accentYellow),
                        const SizedBox(width: 4),
                        Text(restaurant.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(width: 4),
                        Text('(${restaurant.totalReviews})',
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        const Spacer(),
                        Icon(Icons.delivery_dining, size: 16, color: AppTheme.textHint),
                        const SizedBox(width: 4),
                        Text(AppUtils.formatCurrency(restaurant.deliveryFee),
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}