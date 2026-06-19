import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/favorites_controller.dart';
import '../controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.put<FavoritesController>(FavoritesController(), permanent: true);
  }
}
