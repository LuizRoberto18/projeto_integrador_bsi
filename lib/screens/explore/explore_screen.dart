import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../data/accessibility_labels.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/location_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LocationController>();
    final showFilters = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back),
      ),
      body: Obx(() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                // Search
                TextField(
                  onChanged: (v) => ctrl.searchQuery.value = v,
                  decoration: InputDecoration(
                    hintText: 'Restaurante, hospital, escola…',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: ctrl.searchQuery.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.close), onPressed: () => ctrl.searchQuery.value = '')
                        : null,
                  ),
                ),
                const SizedBox(height: 10),

                // Category chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryFilters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final cat = categoryFilters[i];
                      final isActive = ctrl.activeCategory.value == cat['key'];
                      return GestureDetector(
                        onTap: () => ctrl.activeCategory.value = cat['key']!,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive ? AppTheme.primary : Colors.white,
                            border: Border.all(color: isActive ? AppTheme.primary : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('${cat['icon']} ${cat['label']}',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isActive ? Colors.white : const Color(0xFF334155))),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Filter toggle
                OutlinedButton.icon(
                  onPressed: () => showFilters.value = !showFilters.value,
                  icon: const Icon(Icons.tune, size: 16),
                  label: Text('Filtros avançados ${ctrl.selectedFeatures.isNotEmpty || ctrl.minRating.value > 1 ? "(${ctrl.selectedFeatures.length + (ctrl.minRating.value > 1 ? 1 : 0)})" : ""}'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                ),

                // Filter panel
                if (showFilters.value) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nota mínima: ${ctrl.minRating.value.toInt()} estrela(s)', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Slider(
                          value: ctrl.minRating.value,
                          min: 1, max: 5, divisions: 4,
                          activeColor: AppTheme.primary,
                          onChanged: (v) => ctrl.minRating.value = v,
                        ),
                        const Text('Recursos de acessibilidade', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 8),
                        ...accessibilityLabels.entries.map((e) => CheckboxListTile(
                          value: ctrl.selectedFeatures.contains(e.key),
                          onChanged: (_) => ctrl.toggleFeature(e.key),
                          title: Text('${e.value.icon} ${e.value.label}', style: const TextStyle(fontSize: 13)),
                          dense: true,
                          activeColor: AppTheme.primary,
                        )),
                        const SizedBox(height: 8),
                        Row(children: [
                          Expanded(child: OutlinedButton(onPressed: ctrl.clearFilters, child: const Text('Limpar'))),
                          const SizedBox(width: 10),
                          Expanded(child: ElevatedButton(onPressed: () => showFilters.value = false, child: const Text('Aplicar'))),
                        ]),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${ctrl.filtered.length} local(is) encontrado(s)', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Results
          Expanded(
            child: ctrl.filtered.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('🔍', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    const Text('Nenhum local encontrado', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 17)),
                    const SizedBox(height: 4),
                    const Text('Tente ajustar os filtros ou a busca!', style: TextStyle(color: Color(0xFF64748B))),
                    const SizedBox(height: 16),
                    OutlinedButton(onPressed: ctrl.clearFilters, child: const Text('Limpar filtros')),
                  ]))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: ctrl.filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => LocationCard(location: ctrl.filtered[i]),
                  ),
          ),
        ],
      )),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}