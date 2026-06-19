import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/location_card.dart';
import 'map_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LocationController>();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('♿', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 8),
          const Text('INCLUI+', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w800, color: AppTheme.primary)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.explore),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: const [
                    Icon(Icons.search, color: Color(0xFF94A3B8), size: 20),
                    SizedBox(width: 10),
                    Text('Buscar locais acessíveis…', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              // Map
              const Text('📍 Mapa de Acessibilidade', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 17)),
              const SizedBox(height: 10),
              MapSection(locations: ctrl.locations),

              const SizedBox(height: 24),

              // Nearby carousel
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('📍 Próximos a Você', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 17)),
                TextButton(onPressed: () => Get.toNamed(AppRoutes.explore), child: const Text('Ver todos', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 8),
              SizedBox(
                height: 240,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.nearby.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) => LocationCard(location: ctrl.nearby[i], isCarousel: true),
                ),
              ),

              const SizedBox(height: 24),

              // Top rated
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('🏆 Mais Bem Avaliados', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 17)),
                TextButton(onPressed: () => Get.toNamed(AppRoutes.explore), child: const Text('Ver todos', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ctrl.topRated.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => LocationCard(location: ctrl.topRated[i]),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.explore),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Avaliar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}