import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location_model.dart';

final List<Map<String, dynamic>> _seedLocations = [
  {
    'id': 'loc001', 'name': 'Shopping Maceió', 'type': 'Shopping',
    'address': 'Av. Gustavo Paiva, 2990 - Mangabeiras, Maceió - AL',
    'rating': 4.5, 'reviews_count': 42,
    'photo': 'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?w=600&h=400&fit=crop',
    'lat': -9.5830, 'lng': -35.7266,
    'accessibility': {'ramp':true,'adapted_bathroom':true,'pcd_parking':true,'wheelchair_space':true,'audio_signaling':false,'braille':false,'guide_dog':true,'inclusive_service':true},
  },
  {
    'id': 'loc002', 'name': 'UPA Benedito Bentes', 'type': 'Saúde',
    'address': 'R. Nair Miranda, 145 - Benedito Bentes, Maceió - AL',
    'rating': 3.8, 'reviews_count': 19,
    'photo': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?w=600&h=400&fit=crop',
    'lat': -9.5510, 'lng': -35.7540,
    'accessibility': {'ramp':true,'adapted_bathroom':true,'pcd_parking':true,'wheelchair_space':true,'audio_signaling':true,'braille':false,'guide_dog':true,'inclusive_service':true},
  },
  {
    'id': 'loc003', 'name': 'Restaurante Sabor & Arte', 'type': 'Restaurante',
    'address': 'R. Sá e Albuquerque, 55 - Jaraguá, Maceió - AL',
    'rating': 2.3, 'reviews_count': 8,
    'photo': 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=600&h=400&fit=crop',
    'lat': -9.6650, 'lng': -35.7350,
    'accessibility': {'ramp':false,'adapted_bathroom':false,'pcd_parking':false,'wheelchair_space':false,'audio_signaling':false,'braille':false,'guide_dog':false,'inclusive_service':true},
  },
  {
    'id': 'loc006', 'name': 'IFAL — Campus Maceió', 'type': 'Educação',
    'address': 'R. Mizael Domingues, 75 - Jatiúca, Maceió - AL',
    'rating': 4.7, 'reviews_count': 56,
    'photo': 'https://images.unsplash.com/photo-1562774053-701939374585?w=600&h=400&fit=crop',
    'lat': -9.6100, 'lng': -35.7220,
    'accessibility': {'ramp':true,'adapted_bathroom':true,'pcd_parking':true,'wheelchair_space':true,'audio_signaling':true,'braille':true,'guide_dog':true,'inclusive_service':true},
  },
  {
    'id': 'loc011', 'name': 'Hotel Mar Azul', 'type': 'Hospedagem',
    'address': 'Av. Dr. Antônio Gouveia, 1216 - Pajuçara, Maceió - AL',
    'rating': 4.8, 'reviews_count': 61,
    'photo': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=600&h=400&fit=crop',
    'lat': -9.6520, 'lng': -35.7180,
    'accessibility': {'ramp':true,'adapted_bathroom':true,'pcd_parking':true,'wheelchair_space':true,'audio_signaling':true,'braille':true,'guide_dog':true,'inclusive_service':true},
  },
];

Future<void> seedLocations() async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();
  for (final loc in _seedLocations) {
    final id = loc['id'] as String;
    final data = Map<String, dynamic>.from(loc)..remove('id');
    batch.set(db.collection('locations').doc(id), data);
  }
  await batch.commit();
}
