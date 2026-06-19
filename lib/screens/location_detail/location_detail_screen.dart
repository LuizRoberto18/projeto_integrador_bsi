import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/favorites_controller.dart';
import '../../controllers/location_controller.dart';
import '../../data/accessibility_labels.dart';
import '../../models/review_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/star_rating.dart';

class LocationDetailScreen extends StatefulWidget {
  const LocationDetailScreen({super.key});

  @override
  State<LocationDetailScreen> createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  final _locCtrl = Get.find<LocationController>();
  final _favCtrl = Get.find<FavoritesController>();

  List<ReviewModel> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final id = Get.parameters['id'] ?? '';
    final reviews = await _locCtrl.getReviews(id);
    setState(() => _reviews = reviews);
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    final location = _locCtrl.findById(id);

    if (location == null) {
      return Scaffold(
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Local não encontrado', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => Get.offAllNamed(AppRoutes.home), child: const Text('Voltar ao início')),
        ])),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                leading: IconButton(
                  icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back, color: Colors.white)),
                  onPressed: Get.back,
                ),
                actions: [
                  Obx(() => IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)),
                      child: Icon(_favCtrl.isFavorite(id) ? Icons.favorite : Icons.favorite_border, color: _favCtrl.isFavorite(id) ? Colors.red : Colors.white),
                    ),
                    onPressed: () => _favCtrl.toggleFavorite(id),
                  )),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(imageUrl: location.photo, fit: BoxFit.cover),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                sliver: SliverList(delegate: SliverChildListDelegate([
                  // Info card
                  Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(location.name, style: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 20)),
                      const SizedBox(height: 4),
                      Text('${location.type} · ${location.address}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(children: [
                        StarRating(rating: location.rating, size: 18),
                        const SizedBox(width: 8),
                        Text(location.rating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(width: 6),
                        Text('· ${location.reviewsCount} avaliações', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      ]),
                    ],
                  ))),

                  const SizedBox(height: 12),

                  // Accessibility
                  Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('♿ Recursos de Acessibilidade', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 12),
                      ...accessibilityLabels.entries.map((e) {
                        final available = location.accessibility.get(e.key);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${e.value.icon} ${e.value.label}', style: const TextStyle(fontSize: 13)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (available ? AppTheme.secondary : AppTheme.error).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: (available ? AppTheme.secondary : AppTheme.error).withOpacity(0.3)),
                              ),
                              child: Text(available ? '✅ Disponível' : '❌ Não disponível',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: available ? AppTheme.secondary : AppTheme.error)),
                            ),
                          ]),
                        );
                      }),
                    ],
                  ))),

                  const SizedBox(height: 12),

                  // Location buttons
                  Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📍 Localização', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(location.address, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: OutlinedButton.icon(
                          onPressed: () => launchUrl(Uri.parse('https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lng}')),
                          icon: const Icon(Icons.map_outlined, size: 16),
                          label: const Text('Google Maps', style: TextStyle(fontSize: 13)),
                        )),
                        const SizedBox(width: 10),
                        Expanded(child: OutlinedButton.icon(
                          onPressed: () { Clipboard.setData(ClipboardData(text: location.address)); Get.snackbar('Copiado!', 'Endereço copiado.'); },
                          icon: const Icon(Icons.copy, size: 16),
                          label: const Text('Copiar', style: TextStyle(fontSize: 13)),
                        )),
                      ]),
                    ],
                  ))),

                  const SizedBox(height: 12),

                  // Reviews
                  Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('💬 Avaliações da Comunidade', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 12),
                      if (_reviews.isEmpty)
                        const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('Nenhuma avaliação ainda.', style: TextStyle(color: Color(0xFF94A3B8)))))
                      else
                        ..._reviews.map((r) => Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Divider(height: 1),
                            const SizedBox(height: 12),
                            Row(children: [
                              CircleAvatar(backgroundColor: AppTheme.primary.withOpacity(0.1), child: Text(r.userAvatar, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700))),
                              const SizedBox(width: 10),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(r.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                Row(children: [
                                  StarRating(rating: r.rating.toDouble(), size: 14),
                                  const SizedBox(width: 6),
                                  Text(r.createdAt.toLocal().toString().substring(0, 10), style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                                ]),
                              ]),
                            ]),
                            if (r.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(r.text, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.5)),
                            ],
                          ]),
                        )),
                    ],
                  ))),
                ])),
              ),
            ],
          ),

          // CTA button
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor]),
              ),
              child: ElevatedButton(
                onPressed: () => Get.toNamed(AppRoutes.review.replaceFirst(':id', id)),
                child: const Text('✍️ Avaliar este local'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}