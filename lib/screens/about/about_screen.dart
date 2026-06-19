import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_bottom_nav.dart';

class _TeamMember {
  final String name;
  final String role;
  final String icon;
  final Color bgColor;
  final Color textColor;
  const _TeamMember({required this.name, required this.role, required this.icon, required this.bgColor, required this.textColor});
}

const _team = [
  _TeamMember(name: 'Luiz Roberto', role: 'Gerente de Projetos',    icon: '🗂️', bgColor: Color(0xFFDBEAFE), textColor: Color(0xFF1D4ED8)),
  _TeamMember(name: 'Pablo',        role: 'Dev Back-end',            icon: '⚙️', bgColor: Color(0xFFD1FAE5), textColor: Color(0xFF059669)),
  _TeamMember(name: 'Robert Alan',  role: 'Dev Front-end',           icon: '💻', bgColor: Color(0xFFFFEDD5), textColor: Color(0xFFEA580C)),
  _TeamMember(name: 'Werython',     role: 'Dev Front-end',           icon: '💻', bgColor: Color(0xFFFFEDD5), textColor: Color(0xFFEA580C)),
];

String _initials(String name) {
  final parts = name.trim().split(' ');
  return parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre Nós')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(children: [
          // Hero
          Container(width: 80, height: 80, decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
            child: const Center(child: Text('♿', style: TextStyle(fontSize: 36)))),
          const SizedBox(height: 12),
          const Text('INCLUI+', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w800, fontSize: 28, color: AppTheme.primary)),
          const SizedBox(height: 4),
          const Text('"Onde você pode ir. Onde você pertence."', style: TextStyle(color: Color(0xFF64748B), fontStyle: FontStyle.italic, fontSize: 13)),

          const SizedBox(height: 24),

          // O Projeto
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📖 O Projeto', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            const Text(
              'O INCLUI+ é uma plataforma colaborativa de mapeamento de acessibilidade que conecta pessoas '
              'a lugares realmente preparados para recebê-las. Nascemos da inquietação com uma realidade: '
              'no Brasil, mais de 19 milhões de pessoas possuem deficiência física, e para muitas delas '
              'sair de casa ainda é incerteza.',
              style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.6),
            ),
          ]))),

          const SizedBox(height: 16),

          // Missão
          Align(alignment: Alignment.centerLeft, child: const Text('Nossa Missão', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 16))),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1.6,
            children: [
              _MissionCard(icon: Icons.search, text: 'Mapear locais acessíveis com dados reais', color: AppTheme.primary),
              _MissionCard(icon: Icons.people_outlined, text: 'Empoderar a comunidade PCD', color: AppTheme.secondary),
              _MissionCard(icon: Icons.bar_chart, text: 'Transformar informação em liberdade', color: AppTheme.accent),
              _MissionCard(icon: Icons.public, text: 'Gerar impacto social mensurável', color: AppTheme.error),
            ],
          ),

          const SizedBox(height: 16),

          // Equipe
          Align(alignment: Alignment.centerLeft, child: const Text('👥 A Equipe', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 16))),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
            itemCount: _team.length,
            itemBuilder: (_, i) {
              final m = _team[i];
              return Card(child: Padding(padding: const EdgeInsets.all(10), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(radius: 22, backgroundColor: m.bgColor, child: Text(_initials(m.name), style: TextStyle(color: m.textColor, fontWeight: FontWeight.w700, fontSize: 13))),
                const SizedBox(height: 6),
                Text(m.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11), textAlign: TextAlign.center, maxLines: 2),
                const SizedBox(height: 2),
                Text('${m.icon} ${m.role}', style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)), textAlign: TextAlign.center, maxLines: 2),
              ])));
            },
          ),

          const SizedBox(height: 16),

          // IFAL
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('IFAL', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 14)))),
            const SizedBox(height: 10),
            const Text('Nossa Instituição', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 6),
            const Text('Somos estudantes do Bacharelado em Sistemas de Informação do IFAL — Instituto Federal de Alagoas.',
              textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.5)),
          ]))),

          const SizedBox(height: 12),

          // Status badges
          Align(alignment: Alignment.center, child: const Text('📊 Status do Projeto', style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w700, fontSize: 15))),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.center, children: const [
            Chip(label: Text('🚧 Em Desenvolvimento')),
            Chip(label: Text('🎓 Projeto Acadêmico')),
            Chip(label: Text('🌍 Impacto Nacional')),
          ]),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),
          const Text('INCLUI+ © 2025 — IFAL — Sistemas de Informação', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
          const Text('MVP v1.0 — Build de Demonstração', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
        ]),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _MissionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _MissionCard({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 6),
      Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, height: 1.3), textAlign: TextAlign.center),
    ])));
  }
}