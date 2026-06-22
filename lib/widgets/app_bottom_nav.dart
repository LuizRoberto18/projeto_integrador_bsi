import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  static const _items = [
    {'route': AppRoutes.home,      'label': 'Início',    'icon': Icons.home_outlined,    'iconActive': Icons.home},
    {'route': AppRoutes.explore,   'label': 'Explorar',  'icon': Icons.search_outlined,  'iconActive': Icons.search},
    {'route': AppRoutes.favorites, 'label': 'Favoritos', 'icon': Icons.star_outline,     'iconActive': Icons.star},
    {'route': AppRoutes.profile,   'label': 'Perfil',    'icon': Icons.person_outline,   'iconActive': Icons.person},
    {'route': AppRoutes.about,     'label': 'Sobre',     'icon': Icons.info_outline,     'iconActive': Icons.info},
  ];

  int _currentIndex(String route) {
    return _items.indexWhere((i) => i['route'] == route);
  }

  @override
  Widget build(BuildContext context) {
    final current = Get.currentRoute;
    final idx = _currentIndex(current);

    return BottomNavigationBar(
      currentIndex: idx < 0 ? 0 : idx,
      onTap: (i) {
        final route = _items[i]['route'] as String;
        if (Get.currentRoute != route) Get.toNamed(route);
      },
      items: _items.map((item) {
        final isActive = _currentIndex(current) == _items.indexOf(item);
        return BottomNavigationBarItem(
          icon: Icon(isActive ? item['iconActive'] as IconData : item['icon'] as IconData),
          label: item['label'] as String,
        );
      }).toList(),
    );
  }
}