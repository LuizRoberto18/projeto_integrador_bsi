import 'package:cloud_firestore/cloud_firestore.dart';

class AccessibilityFeatures {
  final bool ramp;
  final bool adaptedBathroom;
  final bool pcdParking;
  final bool wheelchairSpace;
  final bool audioSignaling;
  final bool braille;
  final bool guideDog;
  final bool inclusiveService;

  const AccessibilityFeatures({
    this.ramp = false,
    this.adaptedBathroom = false,
    this.pcdParking = false,
    this.wheelchairSpace = false,
    this.audioSignaling = false,
    this.braille = false,
    this.guideDog = false,
    this.inclusiveService = false,
  });

  factory AccessibilityFeatures.fromMap(Map<String, dynamic> map) {
    return AccessibilityFeatures(
      ramp: map['ramp'] ?? false,
      adaptedBathroom: map['adapted_bathroom'] ?? false,
      pcdParking: map['pcd_parking'] ?? false,
      wheelchairSpace: map['wheelchair_space'] ?? false,
      audioSignaling: map['audio_signaling'] ?? false,
      braille: map['braille'] ?? false,
      guideDog: map['guide_dog'] ?? false,
      inclusiveService: map['inclusive_service'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
    'ramp': ramp,
    'adapted_bathroom': adaptedBathroom,
    'pcd_parking': pcdParking,
    'wheelchair_space': wheelchairSpace,
    'audio_signaling': audioSignaling,
    'braille': braille,
    'guide_dog': guideDog,
    'inclusive_service': inclusiveService,
  };

  bool get(String key) {
    switch (key) {
      case 'ramp': return ramp;
      case 'adapted_bathroom': return adaptedBathroom;
      case 'pcd_parking': return pcdParking;
      case 'wheelchair_space': return wheelchairSpace;
      case 'audio_signaling': return audioSignaling;
      case 'braille': return braille;
      case 'guide_dog': return guideDog;
      case 'inclusive_service': return inclusiveService;
      default: return false;
    }
  }
}

class LocationModel {
  final String id;
  final String name;
  final String type;
  final String address;
  final double rating;
  final int reviewsCount;
  final String photo;
  final double lat;
  final double lng;
  final AccessibilityFeatures accessibility;

  const LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.photo,
    required this.lat,
    required this.lng,
    required this.accessibility,
  });

  factory LocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      address: data['address'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviewsCount: data['reviews_count'] ?? 0,
      photo: data['photo'] ?? '',
      lat: (data['lat'] ?? 0).toDouble(),
      lng: (data['lng'] ?? 0).toDouble(),
      accessibility: AccessibilityFeatures.fromMap(data['accessibility'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'type': type,
    'address': address,
    'rating': rating,
    'reviews_count': reviewsCount,
    'photo': photo,
    'lat': lat,
    'lng': lng,
    'accessibility': accessibility.toMap(),
  };
}
