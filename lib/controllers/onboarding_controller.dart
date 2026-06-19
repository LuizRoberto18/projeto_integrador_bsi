import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  static const _key = 'onboarding_seen';

  final RxInt currentSlide = 0.obs;

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  void next() {
    if (currentSlide.value < 2) currentSlide.value++;
  }

  Future<void> complete({bool goToRegister = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
    Get.offAllNamed(AppRoutes.login, arguments: goToRegister ? {'mode': 'register'} : null);
  }
}
