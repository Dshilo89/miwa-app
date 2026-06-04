import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/app_theme.dart';
import 'routes/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/donation_provider.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase abstraction safely (it'll log error if config is missing, but won't crash)
  try {
    await FirebaseService().initialize();
  } catch (e) {
    debugPrint('Firebase initialization deferred: $e');
  }

  runApp(const MiwaApp());
}

class MiwaApp extends StatefulWidget {
  const MiwaApp({super.key});

  @override
  State<MiwaApp> createState() => _MiwaAppState();
}

class _MiwaAppState extends State<MiwaApp> {
  late final AuthProvider _authProvider;
  late final RestaurantProvider _restaurantProvider;
  late final CartProvider _cartProvider;
  late final DonationProvider _donationProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider();
    _restaurantProvider = RestaurantProvider();
    _cartProvider = CartProvider();
    _donationProvider = DonationProvider();
    
    // Initialize provider data
    _authProvider.initialize();
    
    _appRouter = AppRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<RestaurantProvider>.value(value: _restaurantProvider),
        ChangeNotifierProvider<CartProvider>.value(value: _cartProvider),
        ChangeNotifierProvider<DonationProvider>.value(value: _donationProvider),
      ],
      child: MaterialApp.router(
        title: 'MIWA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
