import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

// Screen imports
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/verify_otp_screen.dart';
import '../screens/main_shell.dart';
import '../screens/restaurant_screen.dart';
import '../screens/menu_item_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/order_detail_screen.dart';
import '../screens/donation_screen.dart';
import '../screens/campaign_detail_screen.dart';
import '../screens/wallet_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/addresses_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/search_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/rider_dashboard_screen.dart';
import '../screens/restaurant_dashboard_screen.dart';
import '../screens/admin_dashboard_screen.dart';

// Route names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String verifyOtp = '/verify-otp';
  static const String home = '/home';
  static const String restaurant = '/restaurant';
  static const String menuItem = '/menu-item';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String donation = '/donation';
  static const String campaign = '/campaign';
  static const String wallet = '/wallet';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String settings = '/settings';

  // Rider routes
  static const String riderDashboard = '/rider';
  static const String riderDelivery = '/rider/delivery';

  // Restaurant routes
  static const String restaurantDashboard = '/restaurant-dashboard';
  static const String restaurantOrders = '/restaurant/orders';
  static const String restaurantMenu = '/restaurant/menu';

  // Admin routes
  static const String adminDashboard = '/admin';
  static const String adminUsers = '/admin/users';
  static const String adminDonations = '/admin/donations';
  static const String adminReports = '/admin/reports';
}

/// App Router configuration
class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: _guardRoute,
    routes: _buildRoutes(),
  );

  /// Route guard - redirect based on auth state
  String? _guardRoute(BuildContext context, GoRouterState state) {
    final isLoggedIn = authProvider.isLoggedIn;
    final isAuthRoute = state.matchedLocation == AppRoutes.login ||
        state.matchedLocation == AppRoutes.signUp ||
        state.matchedLocation == AppRoutes.splash ||
        state.matchedLocation == AppRoutes.onboarding;

    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }

    if (isLoggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    return null;
  }

  List<GoRoute> _buildRoutes() {
    return [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyOtp,
        builder: (context, state) => const VerifyOtpScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const MainShell(),
        routes: [
          GoRoute(
            path: 'restaurant/:id',
            builder: (context, state) => RestaurantScreen(
              restaurantId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: 'menu-item/:id',
            builder: (context, state) => MenuItemDetailScreen(
              menuItemId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: 'order-tracking/:id',
            builder: (context, state) => OrderTrackingScreen(
              orderId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: 'orders',
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: 'order/:id',
            builder: (context, state) => OrderDetailScreen(
              orderId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: 'donation',
            builder: (context, state) => const DonationScreen(),
          ),
          GoRoute(
            path: 'campaign/:id',
            builder: (context, state) => CampaignDetailScreen(
              campaignId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: 'wallet',
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'addresses',
            builder: (context, state) => const AddressesScreen(),
          ),
          GoRoute(
            path: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      // Rider routes
      GoRoute(
        path: AppRoutes.riderDashboard,
        builder: (context, state) => const RiderDashboardScreen(),
      ),
      // Restaurant routes
      GoRoute(
        path: AppRoutes.restaurantDashboard,
        builder: (context, state) => const RestaurantDashboardScreen(),
      ),
      // Admin routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ];
  }
}
