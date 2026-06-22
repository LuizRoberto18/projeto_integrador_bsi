import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../theme/app_theme.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final ValueChanged<double>? onChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 18,
    this.interactive = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (interactive) {
      return RatingBar.builder(
        initialRating: rating.toDouble(),
        minRating: 1,
        itemSize: size,
        glow: false,
        itemPadding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (ctx, _) => const Icon(Icons.star, color: AppTheme.accent),
        onRatingUpdate: (v) => onChanged?.call(v),
      );
    }

    return RatingBarIndicator(
      rating: rating.toDouble(),
      itemSize: size,
      itemBuilder: (ctx, _) => const Icon(Icons.star, color: AppTheme.accent),
    );
  }
}