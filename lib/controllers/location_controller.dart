import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/location_model.dart';
import '../models/review_model.dart';

class LocationController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final RxList<LocationModel> locations = <LocationModel>[].obs;
  final RxBool isLoading = false.obs;

  // Explore filters
  final RxString searchQuery = ''.obs;
  final RxString activeCategory = 'all'.obs;
  final RxDouble minRating = 1.0.obs;
  final RxList<String> selectedFeatures = <String>[].obs;

  List<LocationModel> get filtered {
    return locations.where((loc) {
      final matchSearch = searchQuery.isEmpty ||
          loc.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          loc.type.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCat = activeCategory.value == 'all' || loc.type == activeCategory.value;
      final matchRating = loc.rating >= minRating.value;
      final matchFeatures = selectedFeatures.every((f) => loc.accessibility.get(f));
      return matchSearch && matchCat && matchRating && matchFeatures;
    }).toList();
  }

  List<LocationModel> get nearby {
    final sorted = [...locations];
    sorted.sort((a, b) => a.rating.compareTo(b.rating)); // Replace with real distance calc
    return sorted.take(6).toList();
  }

  List<LocationModel> get topRated {
    final sorted = [...locations];
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(5).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    isLoading.value = true;
    final snap = await _db.collection('locations').get();
    locations.assignAll(snap.docs.map((d) => LocationModel.fromFirestore(d)));
    isLoading.value = false;
  }

  LocationModel? findById(String id) {
    try {
      return locations.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<ReviewModel>> getReviews(String locationId) async {
    final snap = await _db
        .collection('reviews')
        .where('location_id', isEqualTo: locationId)
        .orderBy('created_at', descending: true)
        .get();
    return snap.docs.map((d) => ReviewModel.fromFirestore(d)).toList();
  }

  void clearFilters() {
    searchQuery.value = '';
    activeCategory.value = 'all';
    minRating.value = 1.0;
    selectedFeatures.clear();
  }

  void toggleFeature(String key) {
    if (selectedFeatures.contains(key)) {
      selectedFeatures.remove(key);
    } else {
      selectedFeatures.add(key);
    }
  }
}
