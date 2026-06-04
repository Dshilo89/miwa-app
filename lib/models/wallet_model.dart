/// Wallet model for MIWA application
class Wallet {
  final String id;
  final String userId;
  final double balance;
  final double pendingBalance;
  final int loyaltyPoints;
  final List<String> savedCardIds;
  final List<CardInfo> savedCards;
  final DateTime createdAt;
  final DateTime updatedAt;

  Wallet({
    required this.id,
    required this.userId,
    this.balance = 0.0,
    this.pendingBalance = 0.0,
    this.loyaltyPoints = 0,
    this.savedCardIds = const [],
    this.savedCards = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Wallet.fromMap(Map<String, dynamic> data, String id) {
    return Wallet(
      id: id,
      userId: data['userId'] ?? '',
      balance: (data['balance'] ?? 0.0).toDouble(),
      pendingBalance: (data['pendingBalance'] ?? 0.0).toDouble(),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      savedCardIds: List<String>.from(data['savedCardIds'] ?? []),
      savedCards: data['savedCards'] != null
          ? (data['savedCards'] as List).map((e) => CardInfo.fromMap(e)).toList()
          : [],
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'balance': balance,
      'pendingBalance': pendingBalance,
      'loyaltyPoints': loyaltyPoints,
      'savedCardIds': savedCardIds,
      'savedCards': savedCards.map((e) => e.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Card info
class CardInfo {
  final String id;
  final String last4Digits;
  final String cardType;
  final String? expiryDate;
  final String? cardHolderName;
  final bool isDefault;

  CardInfo({
    required this.id,
    required this.last4Digits,
    required this.cardType,
    this.expiryDate,
    this.cardHolderName,
    this.isDefault = false,
  });

  factory CardInfo.fromMap(Map<String, dynamic> data) {
    return CardInfo(
      id: data['id'] ?? '',
      last4Digits: data['last4Digits'] ?? '',
      cardType: data['cardType'] ?? '',
      expiryDate: data['expiryDate'],
      cardHolderName: data['cardHolderName'],
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last4Digits': last4Digits,
      'cardType': cardType,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'isDefault': isDefault,
    };
  }
}

/// Transaction model
class Transaction {
  final String id;
  final String walletId;
  final String type; // credit, debit
  final String category; // order, deposit, donation, withdrawal, refund, tip
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String? description;
  final String? reference;
  final String? orderId;
  final String? donationId;
  final String status; // pending, completed, failed
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.walletId,
    required this.type,
    required this.category,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.description,
    this.reference,
    this.orderId,
    this.donationId,
    this.status = 'completed',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Transaction.fromMap(Map<String, dynamic> data, String id) {
    return Transaction(
      id: id,
      walletId: data['walletId'] ?? '',
      type: data['type'] ?? 'credit',
      category: data['category'] ?? 'order',
      amount: (data['amount'] ?? 0.0).toDouble(),
      balanceBefore: (data['balanceBefore'] ?? 0.0).toDouble(),
      balanceAfter: (data['balanceAfter'] ?? 0.0).toDouble(),
      description: data['description'],
      reference: data['reference'],
      orderId: data['orderId'],
      donationId: data['donationId'],
      status: data['status'] ?? 'completed',
      createdAt: (data['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'walletId': walletId,
      'type': type,
      'category': category,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'description': description,
      'reference': reference,
      'orderId': orderId,
      'donationId': donationId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}