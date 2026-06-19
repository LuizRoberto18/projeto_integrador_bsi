import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/onboarding_controller.dart';
import '../../theme/app_theme.dart';

class _Slide {
  final String emoji;
  final Color color;
  final String title;
  final String subtitle;
  const _Slide({required this.emoji, required this.color, required this.title, required this.subtitle});
}

const _slides = [
  _Slide(emoji: '♿', color: AppTheme.primary,
    title: 'Encontre lugares acessíveis perto de você',
    subtitle: 'Veja rampas, banheiros adaptados, entradas acessíveis e muito mais, com base em avaliações reais.'),
  _Slide(emoji: '🗺️', color: AppTheme.secondary,
    title: 'Avalie e ajude sua comunidade',
    subtitle: 'Sua experiência importa. Avalie locais e ajude outras pessoas a chegarem com segurança.'),
  _Slide(emoji: '🤝', color: AppTheme.primary,
    title: 'Você não está sozinho nessa jornada',
    subtitle: 'O INCLUI+ é feito por e para a comunidade PCD. Juntos transformamos cidades.'),
];

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(OnboardingController());

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final slide = _slides[ctrl.currentSlide.value];
          final isLast = ctrl.currentSlide.value == 2;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => ctrl.complete(),
                  child: const Text('Pular', style: TextStyle(color: Color(0xFF94A3B8))),
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    key: ValueKey(ctrl.currentSlide.value),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96, height: 96,
                        decoration: BoxDecoration(color: slide.color, borderRadius: BorderRadius.circular(24)),
                        child: Center(child: Text(slide.emoji, style: const TextStyle(fontSize: 40))),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(slide.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 22)),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(slide.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 15, height: 1.6)),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == ctrl.currentSlide.value ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == ctrl.currentSlide.value ? AppTheme.primary : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      )),
                    ),
                    const SizedBox(height: 24),
                    if (isLast) ...[
                      ElevatedButton(
                        onPressed: () => ctrl.complete(goToRegister: true),
                        child: const Text('Criar Conta'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => ctrl.complete(),
                        child: const Text('Já tenho conta — Entrar'),
                      ),
                    ] else
                      ElevatedButton(
                        onPressed: ctrl.next,
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          Text('Próximo'),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right, size: 20),
                        ]),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}