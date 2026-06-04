/// Campaign model for MIWA application - Community feeding campaigns
class Campaign {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String type; // community, emergency, corporate
  final String status; // active, completed, cancelled
  final String? organizerId;
  final String? organizerName;
  final double goalAmount;
  final double raisedAmount;
  final int goalMeals;
  final int mealsProvided;
  final int donorCount;
  final DateTime startDate;
  final DateTime endDate;
  final List<String>? sponsorIds;
  final List<String>? sponsoringCompanies;
  final bool isFeatured;
  final DateTime createdAt;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    this.status = 'active',
    this.organizerId,
    this.organizerName,
    required this.goalAmount,
    this.raisedAmount = 0.0,
    this.goalMeals = 0,
    this.mealsProvided = 0,
    this.donorCount = 0,
    required this.startDate,
    required this.endDate,
    this.sponsorIds,
    this.sponsoringCompanies,
    this.isFeatured = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Campaign.fromMap(Map<String, dynamic> data, String id) {
    return Campaign(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      type: data['type'] ?? 'community',
      status: data['status'] ?? 'active',
      organizerId: data['organizerId'],
      organizerName: data['organizerName'],
      goalAmount: (data['goalAmount'] ?? 0.0).toDouble(),
      raisedAmount: (data['raisedAmount'] ?? 0.0).toDouble(),
      goalMeals: data['goalMeals'] ?? 0,
      mealsProvided: data['mealsProvided'] ?? 0,
      donorCount: data['donorCount'] ?? 0,
      startDate: (data['startDate'] as dynamic)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as dynamic)?.toDate() ?? DateTime.now(),
      sponsorIds: data['sponsorIds'] != null
          ? List<String>.from(data['sponsorIds'])
          : null,
      sponsoringCompanies: data['sponsoringCompanies'] != null
          ? List<String>.from(data['sponsoringCompanies'])
          : null,
      isFeatured: data['isFeatured'] ?? false,
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'type': type,
      'status': status,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'goalAmount': goalAmount,
      'raisedAmount': raisedAmount,
      'goalMeals': goalMeals,
      'mealsProvided': mealsProvided,
      'donorCount': donorCount,
      'startDate': startDate,
      'endDate': endDate,
      'sponsorIds': sponsorIds,
      'sponsoringCompanies': sponsoringCompanies,
      'isFeatured': isFeatured,
      'createdAt': createdAt,
    };
  }

  double get progressPercent => goalAmount > 0 ? (raisedAmount / goalAmount).clamp(0.0, 1.0) : 0.0;
  Duration get remainingTime => endDate.difference(DateTime.now());
  bool get isUrgent => remainingTime.inDays <= 7 && status == 'active';
}