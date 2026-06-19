import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? disability;
  final int reviewsCount;
  final List<String> favorites;
  final DateTime memberSince;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.disability,
    this.reviewsCount = 0,
    this.favorites = const [],
    required this.memberSince,
  });

  String get avatarInitials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      disability: data['disability'],
      reviewsCount: data['reviews_count'] ?? 0,
      favorites: List<String>.from(data['favorites'] ?? []),
      memberSince: (data['member_since'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'disability': disability,
    'reviews_count': reviewsCount,
    'favorites': favorites,
    'member_since': Timestamp.fromDate(memberSince),
  };

  UserModel copyWith({
    String? name,
    String? disability,
    int? reviewsCount,
    List<String>? favorites,
  }) {
    return UserModel(
      id: id,
      email: email,
      memberSince: memberSince,
      name: name ?? this.name,
      disability: disability ?? this.disability,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      favorites: favorites ?? this.favorites,
    );
  }
}
