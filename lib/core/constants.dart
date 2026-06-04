/// MIWA App Constants
class AppConstants {
  // App Info
  static const String appName = 'MIWA';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Eat. Donate. Impact.';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String restaurantsCollection = 'restaurants';
  static const String ridersCollection = 'riders';
  static const String ordersCollection = 'orders';
  static const String donationsCollection = 'donations';
  static const String campaignsCollection = 'campaigns';
  static const String notificationsCollection = 'notifications';
  static const String walletsCollection = 'wallets';
  static const String transactionsCollection = 'transactions';
  static const String reviewsCollection = 'reviews';
  static const String categoriesCollection = 'categories';
  static const String menusCollection = 'menus';
  static const String deliveryTrackingCollection = 'delivery_tracking';
  static const String couponsCollection = 'coupons';
  static const String referralsCollection = 'referrals';

  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleRider = 'rider';
  static const String roleRestaurant = 'restaurant';
  static const String roleAdmin = 'admin';

  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderPickedUp = 'picked_up';
  static const String orderInTransit = 'in_transit';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';

  // Donation Types
  static const String donationMeal = 'meal';
  static const String donationMoney = 'money';
  static const String donationSponsorship = 'sponsorship';

  // Payment Methods
  static const String paymentCash = 'cash';
  static const String paymentCard = 'card';
  static const String paymentPaystack = 'paystack';
  static const String paymentFlutterwave = 'flutterwave';
  static const String paymentWallet = 'wallet';

  // Delivery Fee
  static const double baseDeliveryFee = 500.0;
  static const double deliveryFeePerKm = 200.0;
  static const double freeDeliveryThreshold = 5000.0;

  // Wallet
  static const double maxWalletBalance = 1000000.0;
  static const double minWalletDeposit = 100.0;
  static const double maxWalletDeposit = 500000.0;

  // Loyalty Points
  static const double pointsPerNaira = 0.1;
  static const double pointsToNairaRate = 0.01;
  static const int referralPoints = 500;

  // Donation Defaults
  static const double mealCost = 500.0; // Cost to feed one person
  static const List<double> quickDonateAmounts = [500, 1000, 2000, 5000, 10000, 20000];
  static const List<int> quickMealCounts = [1, 2, 5, 10, 20, 50];

  // Pagination
  static const int pageSize = 20;
  static const int searchDebounceMs = 500;

  // Map defaults
  static const double defaultLatitude = 6.5244; // Lagos
  static const double defaultLongitude = 3.3792;
  static const double defaultZoom = 14.0;

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Cache keys
  static const String cacheCart = 'cart_cache';
  static const String cacheUser = 'user_cache';
  static const String cacheSettings = 'settings_cache';
  static const String themePrefKey = 'theme_mode';
  static const String languagePrefKey = 'language';
  static const String onboardingKey = 'onboarding_complete';
  static const String authTokenKey = 'auth_token';
}