import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widgets for MIWA
class AppShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const AppShimmer.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const AppShimmer.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  const AppShimmer.rounded({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder,
        ),
      ),
    );
  }

  /// Skeleton for restaurant card
  static Widget restaurantCard() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const AppShimmer.rounded(width: 80, height: 80),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmer.rectangular(height: 16, width: 150),
                const SizedBox(height: 8),
                const AppShimmer.rectangular(height: 12, width: 200),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const AppShimmer.rectangular(height: 12, width: 40),
                    const SizedBox(width: 10),
                    const AppShimmer.rectangular(height: 12, width: 40),
                    const Spacer(),
                    const AppShimmer.rectangular(height: 12, width: 60),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton for campaign card
  static Widget campaignCard() {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmer.rounded(
            height: 100,
          ),
          const SizedBox(height: 12),
          const AppShimmer.rectangular(height: 14, width: 200),
          const SizedBox(height: 8),
          const AppShimmer.rectangular(height: 10, width: 150),
          const SizedBox(height: 12),
          const AppShimmer.rectangular(height: 6),
        ],
      ),
    );
  }
}
