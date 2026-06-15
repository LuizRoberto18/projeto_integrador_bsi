import 'package:get/get.dart';

import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/location_detail/location_detail_screen.dart';
import '../screens/review/review_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/about/about_screen.dart';

import '../bindings/home_binding.dart';
import '../bindings/auth_binding.dart';
import '../bindings/location_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.explore,
      page: () => const ExploreScreen(),
      binding: LocationBinding(),
    ),
    GetPage(name: AppRoutes.detail, page: () => const LocationDetailScreen()),
    GetPage(name: AppRoutes.review, page: () => const ReviewScreen()),
    GetPage(name: AppRoutes.favorites, page: () => const FavoritesScreen()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),
    GetPage(name: AppRoutes.about, page: () => const AboutScreen()),
  ];
}
