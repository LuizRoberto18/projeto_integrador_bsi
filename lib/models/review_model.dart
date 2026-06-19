import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String locationId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String text;
  final List<String> features;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.locationId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.text,
    required this.features,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      locationId: data['location_id'] ?? '',
      userId: data['user_id'] ?? '',
      userName: data['user_name'] ?? '',
      userAvatar: data['user_avatar'] ?? '',
      rating: data['rating'] ?? 0,
      text: data['text'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'location_id': locationId,
    'user_id': userId,
    'user_name': userName,
    'user_avatar': userAvatar,
    'rating': rating,
    'text': text,
    'features': features,
    'created_at': Timestamp.fromDate(createdAt),
  };
}
