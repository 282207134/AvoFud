import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_state.dart';
import 'core/theme.dart';
import 'data/catalog.dart';
import 'features/auth/onboarding.dart';
import 'features/auth/auth_pages.dart';
import 'features/home/home_pages.dart';
import 'features/shop/catalog_pages.dart';
import 'features/shop/checkout_pages.dart';
import 'features/account/account_pages.dart';
import 'features/account/wallet_pages.dart';
import 'features/discover/discover_pages.dart';

class AvoFudApp extends StatelessWidget {
  const AvoFudApp({
    super.key,
    required this.state,
    this.navigatorKey,
    this.initialRoute = '/splash',
  });
  final AppState state;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String initialRoute;
  @override
  Widget build(BuildContext context) => AppScope(
    state: state,
    child: ListenableBuilder(
      listenable: state,
      builder: (context, _) => MaterialApp(
        title: 'AvoFud',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: appTheme(false),
        darkTheme: appTheme(true),
        themeMode: state.dark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: initialRoute,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: state.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: child!,
        ),
        onGenerateInitialRoutes: (name) => [
          _appRoute(RouteSettings(name: name)),
        ],
        onGenerateRoute: _appRoute,
      ),
    ),
  );
}

Route<void> _appRoute(RouteSettings settings) => MaterialPageRoute<void>(
  settings: settings,
  builder: (context) => switch (settings.name) {
    '/splash' => SplashPage(autoNavigate: settings.arguments != false),
    '/welcome' => const WelcomePage(),
    '/intro-cake' => const IntroPage(index: 0),
    '/intro-tea' => const IntroPage(index: 1),
    '/intro-avocado' => const IntroPage(index: 2),
    '/signin' => const AuthPage(),
    '/signup' => const AuthPage(signUp: true),
    '/otp' => const RecoveryPage(otp: true),
    '/forgot' => const RecoveryPage(),
    '/language' => const LanguagePage(),
    '/home' => const HomePage(),
    '/calendar' => const CalendarPage(),
    '/statistics' => const StatisticsPage(),
    '/shopping' => const ShoppingPage(),
    '/market' => const ShoppingPage(market: true),
    '/detail' => DetailPage(
      item: settings.arguments is Product
          ? settings.arguments as Product
          : product('burger'),
    ),
    '/yogurt' => const YogurtPage(),
    '/dimsum' => const DimsumPage(),
    '/cart' => const CartPage(),
    '/checkout' => const CheckoutPage(),
    '/success' => const ResultPage(),
    '/failure' => const ResultPage(success: false),
    '/account' => const AccountPage(),
    '/settings' => const SettingsPage(),
    '/gallery' => const GalleryPage(),
    '/wallet' => const WalletPage(),
    '/create-card' => const CreateCardPage(),
    '/favorites' => const CollectionPage(kind: 'Love'),
    '/history' => const CollectionPage(kind: 'History'),
    '/rewards' => const CollectionPage(kind: 'Rewards'),
    '/restaurant' => const RestaurantPage(),
    '/reviews' => const ReviewsPage(),
    '/tutorials' => const TutorialsPage(),
    '/empty' => const EmptyPage(),
    _ => const HomePage(),
  },
);
