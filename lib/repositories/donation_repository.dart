import '../core/constants.dart';
import '../models/donation_model.dart';
import '../models/campaign_model.dart';
import '../services/firebase_service.dart';

/// Donation repository
class DonationRepository {
  final FirebaseService _firebase = FirebaseService();

  /// Create donation
  Future<String?> createDonation(Donation donation) async {
    try {
      final docRef = await _firebase.addDocument(AppConstants.donationsCollection, donation.toMap());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  /// Get live donation feed
  Stream<List<Donation>> streamDonationFeed() {
    return _firebase.streamCollection(
      AppConstants.donationsCollection,
      field: 'isFeedVisible',
      isEqualTo: true,
      orderBy: 'createdAt',
      descending: true,
      limit: 50,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Get user donations
  Future<List<Donation>> getUserDonations(String userId) async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.donationsCollection,
        field: 'userId',
        isEqualTo: userId,
        orderBy: 'createdAt',
        descending: true,
      );
      return snapshot.docs.map((doc) =>
          Donation.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Get active campaigns
  Future<List<Campaign>> getActiveCampaigns() async {
    try {
      final snapshot = await _firebase.queryCollection(
        AppConstants.campaignsCollection,
        field: 'status',
        isEqualTo: 'active',
        orderBy: 'createdAt',
        descending: true,
      );
      return snapshot.docs.map((doc) =>
          Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream campaigns
  Stream<List<Campaign>> streamCampaigns() {
    return _firebase.streamCollection(
      AppConstants.campaignsCollection,
      field: 'status',
      isEqualTo: 'active',
      orderBy: 'createdAt',
      descending: true,
    ).map((snapshot) {
      return snapshot.docs.map((doc) =>
          Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    });
  }

  /// Contribute to campaign
  Future<void> contributeToCampaign(String campaignId, double amount, {int? meals}) async {
    await _firebase.firestore.runTransaction((transaction) async {
      final docRef = _firebase.firestore.collection(AppConstants.campaignsCollection).doc(campaignId);
      final doc = await transaction.get(docRef);
      if (!doc.exists) throw Exception('Campaign not found');

      final currentRaised = (doc.data()?['raisedAmount'] ?? 0.0).toDouble();
      final currentMeals = (doc.data()?['mealsProvided'] ?? 0);
      final currentDonors = (doc.data()?['donorCount'] ?? 0);

      transaction.update(docRef, {
        'raisedAmount': currentRaised + amount,
        'mealsProvided': currentMeals + (meals ?? 0),
        'donorCount': currentDonors + 1,
      });
    });
  }

  /// Create campaign
  Future<String?> createCampaign(Campaign campaign) async {
    try {
      final docRef = await _firebase.addDocument(AppConstants.campaignsCollection, campaign.toMap());
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  /// Get campaign by ID
  Future<Campaign?> getCampaignById(String campaignId) async {
    try {
      final doc = await _firebase.getDocument(AppConstants.campaignsCollection, campaignId);
      if (doc.exists) {
        return Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}