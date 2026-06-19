import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/star_rating.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final settings = Get.find<SettingsController>();
    final locCtrl = Get.find<LocationController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Obx(() {
        final user = auth.currentUser.value;
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(children: [
            // User card
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
              CircleAvatar(radius: 32, backgroundColor: AppTheme.primary.withOpacity(0.1),
                child: Text(user.avatarInitials, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 18))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name, style: const TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 17)),
                Text(user.email, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                if (user.disability != null) ...[
                  const SizedBox(height: 4),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text('♿ ${user.disability}', style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w600))),
                ],
              ])),
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
            ]))),

            const SizedBox(height: 12),

            // Stats
            Row(children: [
              _StatCard(icon: Icons.edit, label: 'Avaliações', value: '${user.reviewsCount}', color: AppTheme.primary),
              const SizedBox(width: 10),
              _StatCard(icon: Icons.favorite, label: 'Favoritos', value: '${user.favorites.length}', color: AppTheme.error),
              const SizedBox(width: 10),
              _StatCard(icon: Icons.emoji_events, label: 'Membro', value: 'Desde ${user.memberSince.year}', color: AppTheme.secondary),
            ]),

            const SizedBox(height: 16),

            // Settings card
            Card(
              child: Column(children: [
                const ListTile(title: Text('⚙️ Configurações', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700))),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.contrast, color: AppTheme.accent),
                  title: const Text('Alto contraste', style: TextStyle(fontSize: 14)),
                  trailing: Switch(value: settings.highContrast.value, onChanged: settings.setHighContrast, activeColor: AppTheme.primary),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.text_fields, color: AppTheme.primary),
                  title: const Text('Tamanho do texto', style: TextStyle(fontSize: 14)),
                  trailing: DropdownButton<String>(
                    value: settings.fontSize.value,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'large', child: Text('Grande')),
                      DropdownMenuItem(value: 'xlarge', child: Text('Muito Grande')),
                    ],
                    onChanged: (v) => settings.setFontSize(v!),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined, color: Color(0xFF94A3B8)),
                  title: const Text('Notificações', style: TextStyle(fontSize: 14)),
                  trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppTheme.primary),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: Color(0xFF94A3B8)),
                  title: const Text('Privacidade', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.help_outline, color: Color(0xFF94A3B8)),
                  title: const Text('Ajuda e suporte', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppTheme.error),
                  title: const Text('Sair da conta', style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.w600, fontSize: 14)),
                  onTap: auth.logout,
                ),
              ]),
            ),
          ]),
        );
      }),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Card(child: Padding(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8), child: Column(children: [
      Icon(icon, color: color, size: 22),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
    ]))));
  }
}