import 'package:flutter/material.dart';

/// Campaign detail screen
class CampaignDetailScreen extends StatelessWidget {
  final String campaignId;
  const CampaignDetailScreen({super.key, required this.campaignId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campaign Details')),
      body: Center(child: Text('Campaign $campaignId')),
    );
  }
}
