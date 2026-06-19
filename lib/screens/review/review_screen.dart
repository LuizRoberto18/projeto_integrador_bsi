import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/location_controller.dart';
import '../../controllers/review_controller.dart';
import '../../data/accessibility_labels.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/star_rating.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    final location = Get.find<LocationController>().findById(id);
    final ctrl = Get.put(ReviewController())..reset();

    if (location == null) {
      Get.offAllNamed(AppRoutes.home);
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Avaliar: ${location.name}'), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: Get.back)),
      body: Obx(() {
        if (ctrl.submitted.value) return _SuccessView(locationName: location.name, locationId: id);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Stepper dots
              Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) {
                final s = i + 1;
                return Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: s == ctrl.step.value ? AppTheme.primary : s < ctrl.step.value ? AppTheme.secondary : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text(s < ctrl.step.value ? '✓' : '$s',
                        style: TextStyle(color: s <= ctrl.step.value ? Colors.white : const Color(0xFF94A3B8), fontWeight: FontWeight.w700, fontSize: 13))),
                  ),
                  if (s < 3) Container(width: 32, height: 2, color: s < ctrl.step.value ? AppTheme.secondary : const Color(0xFFE2E8F0)),
                ]);
              })),
              const SizedBox(height: 24),

              // Steps
              Expanded(child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: ctrl.step.value == 1
                    ? _Step1(ctrl: ctrl)
                    : ctrl.step.value == 2
                        ? _Step2(ctrl: ctrl)
                        : _Step3(ctrl: ctrl, locationId: id),
              )),
            ],
          ),
        );
      }),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _Step1 extends StatelessWidget {
  final ReviewController ctrl;
  const _Step1({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(key: const ValueKey(1), mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Qual nota você dá para a acessibilidade?', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 18)),
      const SizedBox(height: 8),
      const Text('Toque nas estrelas para avaliar', style: TextStyle(color: Color(0xFF64748B))),
      const SizedBox(height: 32),
      StarRating(rating: ctrl.rating.value.toDouble(), size: 48, interactive: true, onChanged: (v) => ctrl.rating.value = v.toInt()),
      if (ctrl.rating.value > 0) ...[
        const SizedBox(height: 12),
        Text(ratingLabels[ctrl.rating.value] ?? '', style: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 20)),
      ],
      const Spacer(),
      ElevatedButton(
        onPressed: ctrl.rating.value > 0 ? () => ctrl.step.value = 2 : null,
        child: Row(mainAxisSize: MainAxisSize.min, children: const [Text('Próximo'), SizedBox(width: 6), Icon(Icons.chevron_right)]),
      ),
    ]);
  }
}

class _Step2 extends StatelessWidget {
  final ReviewController ctrl;
  const _Step2({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(key: const ValueKey(2), children: [
      const Text('O que você encontrou neste local?', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 18)),
      const SizedBox(height: 16),
      Expanded(child: ListView(children: accessibilityLabels.entries.map((e) {
        final isSelected = ctrl.selectedFeatures.contains(e.key);
        return GestureDetector(
          onTap: () => ctrl.toggleFeature(e.key),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.secondary.withOpacity(0.1) : Colors.white,
              border: Border.all(color: isSelected ? AppTheme.secondary : const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Text(e.value.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 12),
              Text(e.value.label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? AppTheme.secondary : const Color(0xFF334155))),
            ]),
          ),
        );
      }).toList())),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => ctrl.step.value = 1, icon: const Icon(Icons.chevron_left), label: const Text('Voltar'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(onPressed: () => ctrl.step.value = 3, child: const Text('Próximo'))),
      ]),
    ]);
  }
}

class _Step3 extends StatelessWidget {
  final ReviewController ctrl;
  final String locationId;
  const _Step3({required this.ctrl, required this.locationId});

  @override
  Widget build(BuildContext context) {
    return Column(key: const ValueKey(3), children: [
      const Text('Conte sua experiência', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 18)),
      const SizedBox(height: 4),
      const Text('Opcional — máx. 500 caracteres', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
      const SizedBox(height: 16),
      TextField(
        maxLength: 500,
        maxLines: 4,
        onChanged: (v) => ctrl.text.value = v,
        decoration: const InputDecoration(hintText: 'Como foi sua experiência de acessibilidade neste local?'),
      ),
      const SizedBox(height: 12),
      CheckboxListTile(
        value: ctrl.confirmed.value,
        onChanged: (v) => ctrl.confirmed.value = v ?? false,
        title: const Text('Confirmo que visitei este local', style: TextStyle(fontSize: 13)),
        activeColor: AppTheme.primary,
        dense: true,
      ),
      const Spacer(),
      Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: () => ctrl.step.value = 2, icon: const Icon(Icons.chevron_left), label: const Text('Voltar'))),
        const SizedBox(width: 12),
        Expanded(child: ElevatedButton(
          onPressed: ctrl.confirmed.value ? () => ctrl.submit(locationId) : null,
          child: ctrl.isLoading.value
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Publicar'),
        )),
      ]),
    ]);
  }
}

class _SuccessView extends StatelessWidget {
  final String locationName;
  final String locationId;
  const _SuccessView({required this.locationName, required this.locationId});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.15), shape: BoxShape.circle),
        child: const Icon(Icons.check_circle, color: AppTheme.secondary, size: 40)),
      const SizedBox(height: 20),
      const Text('Avaliação publicada!', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 22)),
      const SizedBox(height: 8),
      const Text('Obrigado por ajudar a comunidade. ❤️', style: TextStyle(color: Color(0xFF64748B))),
      const SizedBox(height: 24),
      Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.secondary.withOpacity(0.2))),
        child: Text('✅ Sua avaliação de "$locationName" foi registrada com sucesso.', style: const TextStyle(color: AppTheme.secondary, fontWeight: FontWeight.w600, fontSize: 13))),
      const SizedBox(height: 24),
      ElevatedButton(onPressed: () => Get.toNamed(AppRoutes.detail.replaceFirst(':id', locationId)), child: const Text('Voltar ao local')),
    ])));
  }
}