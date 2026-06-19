import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/review_model.dart';
import 'auth_controller.dart';

class ReviewController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  final RxInt step = 1.obs;
  final RxInt rating = 0.obs;
  final RxList<String> selectedFeatures = <String>[].obs;
  final RxString text = ''.obs;
  final RxBool confirmed = false.obs;
  final RxBool submitted = false.obs;
  final RxBool isLoading = false.obs;

  void toggleFeature(String key) {
    if (selectedFeatures.contains(key)) {
      selectedFeatures.remove(key);
    } else {
      selectedFeatures.add(key);
    }
  }

  void reset() {
    step.value = 1;
    rating.value = 0;
    selectedFeatures.clear();
    text.value = '';
    confirmed.value = false;
    submitted.value = false;
  }

  Future<void> submit(String locationId) async {
    final user = _auth.currentUser.value;
    if (user == null) return;

    isLoading.value = true;

    final review = ReviewModel(
      id: '',
      locationId: locationId,
      userId: user.id,
      userName: user.name,
      userAvatar: user.avatarInitials,
      rating: rating.value,
      text: text.value,
      features: selectedFeatures.toList(),
      createdAt: DateTime.now(),
    );

    final batch = _db.batch();

    // Add review
    final reviewRef = _db.collection('reviews').doc();
    batch.set(reviewRef, review.toFirestore());

    // Increment user reviews_count
    final userRef = _db.collection('users').doc(user.id);
    batch.update(userRef, {'reviews_count': FieldValue.increment(1)});

    await batch.commit();

    submitted.value = true;
    isLoading.value = false;
  }
}
