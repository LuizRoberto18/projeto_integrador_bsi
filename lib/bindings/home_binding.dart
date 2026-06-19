import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../controllers/review_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController());
    Get.lazyPut(() => ReviewController());
  }
}
