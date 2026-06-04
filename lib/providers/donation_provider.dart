import 'package:flutter/material.dart';
import '../models/donation_model.dart';
import '../models/campaign_model.dart';
import '../repositories/donation_repository.dart';
import '../core/constants.dart';

/// Donation provider with live social feed
class DonationProvider extends ChangeNotifier {
  final DonationRepository _repo = DonationRepository();

  List<Donation> _donationFeed = [];
  List<Campaign> _campaigns = [];
  List<Donation> _userDonations = [];
  bool _isLoading = false;
  String? _error;

  List<Donation> get donationFeed => _donationFeed;
  List<Campaign> get campaigns => _campaigns;
  List<Donation> get userDonations => _userDonations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize donation feed stream
  void initFeedStream() {
    _repo.streamDonationFeed().listen((donations) {
      _donationFeed = donations;
      notifyListeners();
    });

    _repo.streamCampaigns().listen((campaigns) {
      _campaigns = campaigns;
      notifyListeners();
    });
  }

  /// Load user donations
  Future<void> loadUserDonations(String userId) async {
    _isLoading = true;
    notifyListeners();
    _userDonations = await _repo.getUserDonations(userId);
    _isLoading = false;
    notifyListeners();
  }

  /// Create donation
  Future<bool> donate({
    required String userId,
    required String type,
    required double amount,
    int mealCount = 0,
    String? campaignId,
    String? restaurantId,
    bool isAnonymous = false,
    bool isCorporate = false,
    String? corporateName,
    String? message,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final donation = Donation(
        id: '',
        userId: userId,
        type: type,
        amount: amount,
        mealCount: mealCount,
        campaignId: campaignId,
        isAnonymous: isAnonymous,
        isCorporate: isCorporate,
        corporateName: corporateName,
        message: message,
        createdAt: DateTime.now(),
      );

      final docId = await _repo.createDonation(donation);
      
      // Update campaign progress if linked
      if (campaignId != null) {
        await _repo.contributeToCampaign(campaignId, amount, meals: mealCount);
      }

      _isLoading = false;
      notifyListeners();
      return docId != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get AI donation suggestion
  static String getSuggestion(double amount) {
    final meals = (amount / AppConstants.mealCost).floor();
    if (meals >= 100) return '₦${amount.toStringAsFixed(0)} can feed $meals people for a week!';
    if (meals >= 20) return '₦${amount.toStringAsFixed(0)} can feed $meals families!';
    if (meals >= 5) return '₦${amount.toStringAsFixed(0)} can provide $meals warm meals!';
    return '₦${amount.toStringAsFixed(0)} can feed 1 person today!';
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}