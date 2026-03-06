// MIT License - Copyright (c) 2026 InfraGuard AI Contributors
// InfraGuard AI - Settings Screen

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/ghana_proverbs.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../shared/models/sample_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = true;
  bool _offlineMode = false;
  bool _notifications = true;
  String _voiceLang = 'Twi';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = SampleData.demoUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(pinned: true, title: Text('Settings')),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile
                GlassCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.ghanaGold.withValues(alpha: 0.2),
                        child: Text('KA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.ghanaGold)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            Text(user.email, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
                            const SizedBox(height: 4),
                            StatusBadge(label: user.role.label, color: AppColors.ghanaGold),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Appearance
                _label('Appearance'),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(children: [
                    _tile(Icons.dark_mode, 'Dark Mode', 'Night field work', Switch.adaptive(value: _darkMode, activeColor: AppColors.ghanaGold, onChanged: (v) => setState(() => _darkMode = v))),
                  ]),
                ),
                const SizedBox(height: 24),

                // Voice
                _label('Voice Input'),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: _tile(Icons.mic, 'Voice Language', _voiceLang, DropdownButton<String>(
                    value: _voiceLang,
                    underline: SizedBox(),
                    items: ['Twi','Ga','Ewe','English'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                    onChanged: (v) => setState(() => _voiceLang = v!),
                  )),
                ),
                const SizedBox(height: 24),

                // Offline
                _label('Offline & Data'),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(children: [
                    _tile(Icons.wifi_off, 'Offline Mode', 'Maps & AI models', Switch.adaptive(value: _offlineMode, activeColor: AppColors.ghanaGold, onChanged: (v) => setState(() => _offlineMode = v))),
                    Divider(height: 0),
                    _tile(Icons.sync, 'Last Sync', '2 min ago', Icon(Icons.chevron_right, color: Colors.grey)),
                  ]),
                ),
                const SizedBox(height: 24),

                // Notifications
                _label('Notifications'),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: _tile(Icons.notifications, 'Push Alerts', 'Outages & work orders', Switch.adaptive(value: _notifications, activeColor: AppColors.ghanaGold, onChanged: (v) => setState(() => _notifications = v))),
                ),
                const SizedBox(height: 24),

                // About
                _label('About'),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(children: [
                    _tile(Icons.info_outline, 'Version', '1.0.0', null),
                    Divider(height: 0),
                    _tile(Icons.shield_outlined, 'Privacy', 'Ghana DPA compliant', null),
                    Divider(height: 0),
                    _tile(Icons.description, 'License', 'MIT – Open Source', null),
                  ]),
                ),
                const SizedBox(height: 24),

                // Proverb
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.ghanaGold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(children: [
                    Text('🇬🇭 Ghanaian Wisdom', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ghanaGold)),
                    const SizedBox(height: 8),
                    Text(GhanaProverbs.random, style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic), textAlign: TextAlign.center),
                  ]),
                ),
                const SizedBox(height: 24),

                // Logout
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.logout, color: AppColors.ghanaRed),
                    label: Text('Sign Out', style: TextStyle(color: AppColors.ghanaRed)),
                  ),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)));

  Widget _tile(IconData icon, String title, String sub, Widget? trail) => ListTile(
    leading: Icon(icon, color: AppColors.ghanaGold, size: 22),
    title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
    subtitle: Text(sub, style: TextStyle(fontSize: 12)),
    trailing: trail,
  );
}
