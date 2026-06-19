import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class FavoritesController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  final RxList<String> favorites = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    ever(_auth.currentUser, (_) => _loadFavorites());
    _loadFavorites();
  }

  void _loadFavorites() {
    final user = _auth.currentUser.value;
    if (user != null) {
      favorites.assignAll(user.favorites);
    }
  }

  bool isFavorite(String locationId) => favorites.contains(locationId);

  Future<void> toggleFavorite(String locationId) async {
    final user = _auth.currentUser.value;
    if (user == null) return;

    if (favorites.contains(locationId)) {
      favorites.remove(locationId);
    } else {
      favorites.add(locationId);
    }

    await _db.collection('users').doc(user.id).update({
      'favorites': favorites.toList(),
    });
  }
}
