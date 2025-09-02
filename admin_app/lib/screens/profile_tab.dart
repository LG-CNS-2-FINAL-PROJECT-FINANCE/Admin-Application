import 'package:admin_app/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../widgets/tiny_badge.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 48,
            backgroundImage: const AssetImage('assets/sample.jpeg'),
            backgroundColor: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'Admini',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Detail  ›',
              style: TextStyle(color: Colors.black54),
            ),
          ),
          const Divider(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickItem(
                  icon: Icons.favorite_rounded,
                  label: 'ToDoList',
                  badge: '12',
                ),
                _QuickItem(
                  icon: Icons.archive_outlined,
                  label: 'Record',
                  badge: '2',
                ),
                _QuickItem(
                  icon: Icons.notifications_active_rounded,
                  label: 'Hurry',
                  badge: '2',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;
  const _QuickItem({
    required this.icon,
    required this.label,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.black87),
            ),
            Positioned(right: -4, top: -4, child: TinyBadge(badge)),
          ],
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
