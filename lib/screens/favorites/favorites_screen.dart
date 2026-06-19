import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/location_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/location_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favCtrl = Get.find<FavoritesController>();
    final locCtrl = Get.find<LocationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('⭐ Meus Favoritos')),
      body: Obx(() {
        final favLocations = locCtrl.locations.where((l) => favCtrl.favorites.contains(l.id)).toList();

        if (favLocations.isEmpty) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.grey.withOpacity(0.3)),
              const SizedBox(height: 16),
              const Text('Você ainda não salvou nenhum local', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 18), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('Explore e favorite os locais que quiser revisitar', style: TextStyle(color: Color(0xFF64748B)), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.explore),
                icon: const Icon(Icons.search),
                label: const Text('Explorar locais'),
              ),
            ]),
          ));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favLocations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => LocationCard(location: favLocations[i]),
        );
      }),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}