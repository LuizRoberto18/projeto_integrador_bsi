import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../models/location_model.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../data/accessibility_labels.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final bool isCarousel;

  const LocationCard({super.key, required this.location, this.isCarousel = false});

  Color _ratingColor(double r) {
    if (r >= 4) return AppTheme.secondary;
    if (r >= 2.5) return AppTheme.accent;
    return AppTheme.error;
  }

  List<AccessibilityLabel> _topFeatures() {
    return accessibilityLabels.entries
        .where((e) => location.accessibility.get(e.key))
        .take(3)
        .map((e) => e.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.detail.replaceFirst(':id', location.id)),
      child: isCarousel ? _buildCarousel(context) : _buildHorizontal(context),
    );
  }

  Widget _buildCarousel(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: location.photo,
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(location.type, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                const SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.star, size: 14, color: _ratingColor(location.rating)),
                  const SizedBox(width: 3),
                  Text(location.rating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _ratingColor(location.rating))),
                  const SizedBox(width: 4),
                  Text('(${location.reviewsCount})', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                ]),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _topFeatures().map((f) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text('${f.icon} ${f.label}', style: const TextStyle(fontSize: 9, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontal(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: CachedNetworkImage(imageUrl: location.photo, width: 100, height: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(location.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${location.type}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: _ratingColor(location.rating)),
                    const SizedBox(width: 3),
                    Text(location.rating.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _ratingColor(location.rating))),
                    const SizedBox(width: 4),
                    Text('(${location.reviewsCount})', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ]),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _topFeatures().map((f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.secondary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text('${f.icon} ${f.label}', style: const TextStyle(fontSize: 9, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}